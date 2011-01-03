/**
 * @author karidyang
 */
$(function(){
    $("#house_tree")
    .bind("loaded.jstree", function (event, data) {
        check_house();
	})
    .jstree({
      "json_data": {
      "ajax": { //配置采用ajax方式获取数据
      "url": "/houses/house_tree"
      }
      },
      "themes": {
      "url": "/stylesheets/themes/apple/style.css",
      "theme": "apple",
      "dots": true,
      "icons": true
      },
      "plugins": ["themes", "json_data", "checkbox"]
    });
});

function check_all(){
  $("#house_tree").jstree("check_all");
  $("#house_tree").jstree("uncheck_node",$("#h-1"));
}

function getHouseIds(){
  var idArray = new Array();
  $("#house_tree").find("> ul > .jstree-checked, .jstree-undetermined > ul > .jstree-leaf > .jstree-checked").each(function(){
        idArray.push($(this).attr("id"));
      });
  var ids=idArray.join(',');
  $("#house_ids").attr("value",ids);
}

function check_house(){
  $('li[type=3]').each(function(){$('#house_tree').jstree('check_node',this);});
}
