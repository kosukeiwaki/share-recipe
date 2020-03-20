# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


# データベース設計

## usersテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|email|string|null: false, unique: true|
|password|string|null: false, unique: true|


### Association
- has_many :recipes
- has_many :likes
- has_many :comments
- has_many :sns_credentials


## recipesテーブル

|Column|Type|Options|
|------|----|-------|
|name|integer|null: false|
|title|integer|null: false|
|text|string|null: false|
|image|string|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- has_many :likes
- has_many :comments


## commentsテーブル

|Column|Type|Options|
|------|----|-------|
|text|text|null: false|
|recipe_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|


### Association
- belongs_to :user
- belongs_to :recipe

## likesテーブル

|Column|Type|Options|
|------|----|-------|
|recipe_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :recipe


## snsCredentialsテーブル

|Column|Type|Options|
|------|----|-------|
|proveider|string|null: false|
|uid|string|null: false|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user

# アプリケーション概要（なぜ創ったか）

share-recipeは、ただのレシピを見ることができるアプリケーションではありません。
今日のご飯をランダムで選んでくれるサービスです。
毎日の献立やメニューを考える主婦の皆様のストレスを軽減したく作成しました。私が、母とスーパーに晩ご飯の買い物に行った際、どんな料理を創るか決めていないから買い物に時間がかかるし、無駄な食材を買ってしまう。そんな話を聞いたことがきっかけです。

料理の段階は

何を創るかを決める
↓
買い物に行く
↓
レシピを見ながら創る

という3つの大枠に分解できると考えます。従来の『料理方法を助ける』レシピアプリではなく、料理において最も根本の『何を創るか』を手助けするサービスを作成したいと考えました。


# 実装した機能

## レシピ投稿機能

料理名とその思い出をシェアできる機能を実装しました。
投稿時にログインしているユーザーのidとnameを保存できるようにしています。
今後は画像を複数枚投稿できるように実装予定です。

```ruby
def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    @recipe.name = current_user.name
    if @recipe.save
      redirect_to root_path
    else
      flash[:notice] = '画像、テキスト、料理名を入力してください'
      redirect_to new_recipe_path
    end
  end
```

投稿のvalidateは全て記入しないと投稿できないようになっており、保存されない場合は再度投稿画面にリダイレクトするようになっています。

```ruby
  validates :text, presence: true
  validates :title, presence: true
  validates :image, presence: true

  # ストロングパラメータ
    private
  def recipe_params
    params.require(:recipe).permit(:name, :title, :image, :text)
  end
```

## ログイン機能
deviseを利用したログイン機能を実装しています。

ローカルではgoogle認証を使ったログイン機能も実装（現在、google認証を行っています。）しており、ユーザーがログインしやすいように実装しました。

omniauthというgemを使って実装しております。

通常のログイン
https://gyazo.com/1230c907ec25218144b7f85d163b0d67

googleでのログイン(ローカルのみ)
https://gyazo.com/f816d8d7b80c19e4e19886108fa1be4b


## いいね（お気に入り機能）

ユーザーがランダム取得したレシピをストックしてすぐに見れるようにする為に、いいね機能を実装しました。

ユーザー、投稿が削除されると一緒に削除されるようになっております。
model/like.rb

```ruby
class Like < ApplicationRecord
  validates :user_id, {presence: true}
  validates :recipe_id, {presence: true}

  belongs_to :user, dependent: :destroy
  belongs_to :recipe, dependent: :destroy
end
```

レシピを引数にとり、likeが存在するかどうかのメソッドをuserモデルで定義しています。
model/user.rb

```ruby
def already_liked?(recipe)
  likes.exists?(recipe_id: recipe.id)
end

```


if文を使い、likeがある場合はdestory、ない場合はcreateができるように条件分岐しています。
veiw/recipe/show.html.haml

```ruby
- if current_user.already_liked?(@recipe)
  = button_to 'リストから外す', recipe_like_path(@recipe), method: :delete,class:"like-btn"
- else
  = button_to 'お気に入りリストに追加', recipe_likes_path(@recipe),class:"like-btn"
```


いいねしたレシピをすぐに見ることができるように、rootの画面にいいねしたレシピを一覧で表示できるようにしております。
veiw/recipe/index.html.haml

```ruby
.favorite
  お気に入りのレシピ
%ul 
  -if @likes.present?
    - @likes.each do |like|
      - recipe = Recipe.find_by(id: like.recipe_id)
      %li= link_to recipe.title, "/recipes/#{recipe.id}", method: :get
  -else
    no favorite
```

## コメント機能
ユーザー間の交流や、より良いレシピになるアドバイスを書けるように、コメント機能を実装しました。

こちらも、レシピとユーザーの削除と同時に削除されるようになっています。
model/comment.rb

```ruby
class Comment < ApplicationRecord
  validates :user_id, {presence: true}
  validates :recipe_id, {presence: true}
  validates :text, presence: true

  belongs_to :recipe, dependent: :destroy
  belongs_to :user, dependent: :destroy
end
```

コメントはcreateとshowアクションを定義しています。コメントは非同期で遅れるように実装している為、createにjsonを利用しています。
（コメント機能は表示に少しバグがあります。そこは修正予定です。）

``` ruby
def create
  @comment = Comment.create(comment_params)
  respond_to do |format|
    format.html { redirect_to "/recipes/#{@comment.recipe.id}" }
    format.json
  end
end

def show
  @comment = Comment.new
  @comments = @recipe.comments.includes(:user).order(created_at: :desc)
end
```

コメントを非同期で送信できるように、javascriptを利用しました。
javascript/comment.js

```ruby
$(function(){
  function buildHTML(comment){
    var html = `
                ${comment.user_name}
                ：
                ${comment.text} 
                `
    return html;
  }
  $('#new_comment').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action');
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      var html = buildHTML(data);
      $('.comments').append(html);
      $('.textbox').val('');
      $('.form__submit').prop('disabled', false);
    })
    .fail(function(data){
      console.log(data);
      alert('コメントを送信できませんでした。');
    })
  });
});
```

### 実際の画面

https://gyazo.com/90a6b0cceca132cd5466fcca537e1715

※こちら、連続で投稿すると表示のバグが起きてしまいます。

https://gyazo.com/a82738efbba140b5ff9d156a65a315e7



## ランダム取得機能
ユーザーが献立を決める際の意思決定時間を早める為、レシピをランダムで取得する機能を実装しました。

https://gyazo.com/b1512c37087611ed4cf4ec7a3443fb21

randomアクションを作成し、recipeにrouteをネストさせています。
ランダムで1つだけ取り出すようにしております。

controller/recipes_controller

```ruby
def random
  @randoms = Recipe.order("RAND()").limit(1)
  @random = Recipe.new
  if params[:submit]
    @random.score += 1
  elsif params[:btn2]
    @random.score -= 1
  end
end

```

# 全体のrouting

``` ruby
Rails.application.routes.draw do
  devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations'
}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "recipes#index"

  namespace :recipes do
    resources :searches, only: :index
  end

  resources :users, only: [:edit, :update, :destroy]
  resources :recipes do 
    collection do
      get 'random'
    end
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :show]
  end
  

end
```


# 反省、今後について

1.コメント機能のバグを修正
2.コメント機能の削除、編集機能を追加
3.google認証を終わらせて本番環境でも動くようにする
4.いいね機能をajaxを利用し非同期にする
5.メディアクエリによるレスポンシブ対応（現在bootstrap利用）
6.scssのリファクタリング

今後は、こちらのアプリをよりブラッシュアップして、年代と地域などの情報をユーザー情報として集め、データにできれば良いなと考えています。

初めて1人で作成したアプリケーションなのでコードが汚いのですが、書いていて本当に楽しく、やりがいを感じました。share-recipeを創り、より一層エンジニアへの志望度が増しました。


# 全体のUI

https://gyazo.com/ee0b69f36c6f14ee70bf8e0a8444599d

ログインすると、マイページ（root）に飛ぶようになっています。左下の画面で過去のユーザーが投稿したレシピが見れるようになっており、右のサイドバーにお気に入り、自分の過去のレシピが表示されるようになっております。


