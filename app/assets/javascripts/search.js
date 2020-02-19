$(function() {
  var search_list = $(".contents.row");

  function appendRecipe(recipe) {
    var html = ` .recipeHeader
    = ${recipe.name}
    さんの今日のご飯
    .time
      = recipe.created_at.strftime("%Y年%m月%d日")
  .recipeDetail
    .recipeImage
      = image_tag recipe.image, size: "300x180" if recipe.image.present?
    -# .recipeImage{:style => "background-image: url(#{recipe.image});"}
    .recipeBox
      .recipeTitle
        料理名：
        = recipe.title
      .recipememory
        思い出：
        = recipe.text             
      .comment
        = link_to '詳しく見る', "/recipes/#{recipe.id}", method: :get`
    search_list.append(html);
  }
  $(".search-input").on("keyup", function() {
    var input = $(".search-input").val();
    $.ajax({
      type: 'GET',
      url: '/recipes/search',
      data: { keyword: input },
      dataType: 'json'
    })
    .done(function(recipes) {
      $(".postBox").empty();
      if (recipes.length !== 0) {
        recipes.forEach(function(recipe){
          appendRecipe(recipe);
        });
      }
      else {
        appendErrMsgToHTML("一致するレシピがありません");
      }
    })
  });
});