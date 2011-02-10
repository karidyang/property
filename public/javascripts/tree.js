/**
 * @author karidyang
 */
$(function(){
    $("#tree").jstree({
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
        "plugins": ["themes", "json_data"]
    
    }).bind('click.jstree', function(event){
        var eventNodeName = event.target.nodeName;
        if (eventNodeName == 'INS') {
            return;
        }
        else 
            if (eventNodeName == 'A') {
                var $subject = $(event.target).parent();
                if ($subject.find('ul').length <= 0) {
                    var houseCode = $subject.text().trim();
//                    var src = "/houses/info/1?houseCode=" + houseCode;
					clickTreeNode(houseCode);
                }
            }
    });
    
});
