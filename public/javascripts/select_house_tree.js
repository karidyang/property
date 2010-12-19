/**
 * @author karidyang
 */
$(function(){
    $("#house_tree").jstree({
        "json_data": {
            "ajax": { //配置采用ajax方式获取数据
                "url": "/houses/house_tree/1",
                "data": function(n){
                    return {
                        "treeid": n.attr ? n.attr("id") : 0,
                        "type": n.attr ? n.attr("type") : 0
                    };
                }
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

function getHouseIds(){
  var idArray = new Array();
  $("#house_tree").find("> ul > .jstree-checked, .jstree-undetermined > ul > .jstree-checked").each(function(){
        var isChild = true;
        if($(this).find('li').length != 0){
          isChild = false;
        }
        if(!isChild){
          $(this).find('li').each(function(){
            if ($(this).attr("type") == 3){
              idArray.push($(this).attr("id"));
            }
          });
        }
    });
  var ids=idArray.join(',');
  $("#house_ids").attr("value",ids);
} 
