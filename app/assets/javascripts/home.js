/**
 *
 * Created with JetBrains RubyMine.
 * User: karidyang
 * Date: 13-4-29
 * Time: 下午5:15
 * To change this template use File | Settings | File Templates.
 */

function refresh_house1(house_code) {
  alert(house_code);
}


function refresh_house(house_code) {
  $("#select_account_all").removeAttr("checked");
  $("#select_bill_all").removeAttr("checked");
  var url = "<%=url_for(:controller => :houses,:action => :house_info) %>";
  if (house_code == null)
    house_code = $("#house_code").val();
  $.post(url, {"house_code": house_code}, function (data) {
    if (data.house) {
      $("#house_id").val(data.house.id);
      $('#house_base_info tbody tr').each(function () {
        $(this).remove();
      });
      var html = "<tr><td>" + data.house.house_code + "</td>" +
          "<td>" + data.house.owner_name + "</td>" +
          "<td>" + data.house.builded_area + "平方米</td>" +
          "<td>" + data.house.use_type + "</td></tr>";

      $("#house_base_info tbody").append(html);
    }
    $('#accounts_table tbody tr').each(function () {
      $(this).remove();
    });
    if (data.accounts) {
      for (i = 0; i < data.accounts.length; i++) {
        var account = data.accounts[i];
        var account_html = "<tr>" +
            "<td><input type='checkbox' name='account_ids' id='account_ids' value='" + account.id + "' /></td>" +
            "<td>" + account.item_name + "</td>" +
            "<td>" + account.money + "</td>" +
            "<td>" + account.can_push + "</td>" +
            "<td>" +
            "<a href='/accounts/history/" + account.id + "'>历史记录</a>" +
            "</td></tr>";
        $("#accounts_table tbody").append(account_html);
      }


    }

    if (data.cars) {
      for (i = 0; i < data.cars.length; i++) {
        var car = data.cars[i];
        var car_html = "<tr>" +
            "<td>" + cars.id + "</td>" +
            "<td>" + cars.card + "</td>" +
            "<td>" + cars.person + "</td>" +
            "<td>" + cars.validateDate + "</td>";
        $("#cars_table tbody").append(car_html);
      }


    }


    $("#bill_items_table tbody tr").each(function () {
      $(this).remove();
    });
    $("#pay_bill_items_table tbody tr").each(function () {
      $(this).remove();
    });
    if (data.bill_items) {
      parse_bill_item(data.bill_items);
    }
    if (data.pay_bill_items) {
      parse_pay_bill_item(data.pay_bill_items);
    }

  });
}
function search_bill_item() {
  var url = "<%=url_for(:controller => :bills,:action => :search) %>";
  var house_code = $("#house_code").val();
  var start_time = $("#start_time").val();
  var end_time = $("#end_time").val();
  var charge_type = 0;
  if (house_code == '') {
    alert("未选择房间");
    return;
  }
  if (start_time == "") {
    alert("未填写开始时间");
    return;
  }
  if (end_time == "") {
    alert("未填写结束时间");
    return;
  }
  $.post(url, {"house_code": house_code, "start_time": start_time, "end_time": end_time, "charge_type": charge_type}, function (data) {
    $("#bill_items_table tbody tr").each(function () {
      $(this).remove();
    });
    if (data.bill_items) {
      parse_bill_item(data.bill_items)
    }

  }, "json");
}

function parse_bill_item(bill_items) {
  var sum_money = 0;
  for (i = 0; i < bill_items.length; i++) {
    var obj = bill_items[i];
    var tr_row = "<tr>";
    //                    if (obj.status != 1) {
    tr_row += "<td><input type='checkbox' name='bill_item_ids' id='bill_item_ids' value='" + obj.id + "' /></td>";
    //                    } else {
    //                        tr_row += "<td><input type='checkbox' name='bill_item_ids' id='bill_item_ids' value='" + obj.id + "' checked='checked' disabled='disabled' /></td>";
    //                    }

    tr_row += "<td>" + obj.item_name + "</td>" +
        "       <td>" + obj.trans_time + "</td>";
    if (obj.status == 0) {
      tr_row += "<td id='bill_item_" + obj.id + "'>未收</td>";
    } else {
      tr_row += "<td id='bill_item_" + obj.id + "'>已收</td>";
    }

    tr_row += "       <td>" + obj.unit_price + "</td>" +
        "       <td>" + obj.money + "</td>" +
        "       <td>" + obj.push + "</td>" +
        "       <td>0.00</td>" +
        "       <td>" + (obj.money - obj.push - obj.pay_money) + "</td>" +
        "       <td>" + obj.pay_money + "</td>";

// "       <td>" + obj.start_record + "</td>" +
// "       <td>" + obj.end_record + "</td>";
    if (obj.receipt_no == null) {
      tr_row += "  <td></td>";
    } else {
      tr_row += "       <td><a href='javascript:receipt_show(" + obj.receipt_no + ");'>" + obj.receipt_no + "</a></td>";
    }
    tr_row += "</tr>";
    if (obj.status == 0) {
      sum_money += parseFloat(obj.money - obj.push);
    }
    $("#bill_items_table tbody").append(tr_row);
  }

  $("#bill_items_table tbody").append("<tr><td></td><td>欠费合计</td><td></td>" +
      "<td></td><td></td><td></td><td></td><td></td><td>" + sum_money + "</td><td></td><td></td></tr>");

}

function parse_pay_bill_item(bill_items) {
  var sum_money = 0;
  for (i = 0; i < bill_items.length; i++) {
    var obj = bill_items[i];
    var tr_row = "<tr>";
    //                    if (obj.status != 1) {
    tr_row += "<td><input type='checkbox' name='pay_bill_item_ids' id='pay_bill_item_ids' value='" + obj.id + "' /></td>";
    //                    } else {
    //                        tr_row += "<td><input type='checkbox' name='bill_item_ids' id='bill_item_ids' value='" + obj.id + "' checked='checked' disabled='disabled' /></td>";
    //                    }

    tr_row += "<td>" + obj.item_name + "</td>" +
        "       <td>" + obj.trans_time + "</td>";
    if (obj.status == 0) {
      tr_row += "<td id='pay_bill_item_" + obj.id + "'>未收</td>";
    } else {
      tr_row += "<td id='pay_bill_item_" + obj.id + "'>已收</td>";
    }

    tr_row += "       <td>" + obj.unit_price + "</td>" +
        "       <td>" + obj.money + "</td>" +
        "       <td>" + obj.push + "</td>" +
        "       <td>0.00</td>" +
        "       <td>" + (obj.money - obj.push - obj.pay_money) + "</td>" +
        "       <td>" + obj.pay_money + "</td>";

    // "       <td>" + obj.start_record + "</td>" +
    // "       <td>" + obj.end_record + "</td>";
    if (obj.receipt_no == null) {
      tr_row += "  <td></td>";
    } else {
      tr_row += "       <td><a href='javascript:receipt_show(" + obj.receipt_no + ");'>" + obj.receipt_no + "</a></td>";
    }
    tr_row += "</tr>";
    if (obj.status == 1) {
      sum_money += parseFloat(obj.pay_money);
    }
    $("#pay_bill_items_table tbody").append(tr_row);
  }

  $("#pay_bill_items_table tbody").append("<tr><td></td><td>缴费合计</td><td></td>" +
      "<td></td><td></td><td></td><td></td><td></td><td></td><td>" + sum_money + "</td><td></td></tr>");

}

function selectAllCheck(allCheckedObj, id) {
  var isAll = $(allCheckedObj).attr("checked");
  if (isAll) {
    $(":checkbox").each(function () {
      if (this.id == id) {
        if (!this.checked && !this.disabled) {
          this.checked = true;
        }
      }
    });
  } else {
    $(":checkbox").each(function () {
      if (this.id == id) {
        if (this.checked && !this.disabled) {
          this.checked = false;
        }
      }
    });
  }
}

function add_pre_money() {
  var house_code = $("#house_code").val();
  if (house_code == '') {
    alert("未选择房间");
    return;
  }
  var url = "<%=url_for(:controller => :accounts, :action => :add_pre_money) %>";
  url += "/" + $("#house_id").val();
  document.location.href = url;
}

function add_temporary() {
  var house_code = $("#house_code").val();
  if (house_code == '') {
    alert("未选择房间");
    return;
  }
  var url = "<%=url_for(:controller => :bills, :action => :add_temporary) %>";
  url += "/" + $("#house_id").val();
  document.location.href = url;
}
function pay() {
  var house_code = $("#house_code").val();
  if (house_code == '') {
    alert("未选择房间");
    return;
  }
  var url = "<%=url_for(:controller => :bills,:action=>:pay) %>";
  url += "?house_id=" + $("#house_id").val();
  $("input[name='bill_item_ids']").each(function () {
    if (this.checked && $("#bill_item_" + this.value).text() != '已收') {
      url += "&bill_item_ids[]=" + this.value;
    }
  });
  $.post(url, function (data) {
    if (data.result == 'success') {
      alert(data.msg);
      refresh_house();
    }
  });
}
function push() {
  var house_code = $("#house_code").val();
  if (house_code == '') {
    alert("未选择房间");
    return;
  }
  var url = "<%=url_for(:controller => :bills,:action=>:push) %>";
  url += "?house_id=" + $("#house_id").val();
  $("input[name='bill_item_ids']").each(function () {
    if (this.checked && $("#bill_item_" + this.value).text() != '已收') {
      url += "&bill_item_ids[]=" + this.value;
    }
  });
  $.post(url, function (data) {
    if (data.result == 'success') {
      alert(data.msg);
      refresh_house();
    } else {
      alert(data.msg);
    }
  });
}
function print() {
  var house_code = $("#house_code").val();
  if (house_code == '') {
    alert("未选择房间");
    return;
  }
  var url = "<%=url_for(:controller => :receipt,:action=>:print) %>";
  url += "?houseId=" + $('#house_id').val() + "&type=0";
  var flag = false;
  var sum_checked = 0;
  var hasNoPay = false;
  $("input[name='pay_bill_item_ids']").each(function () {
    if (this.checked) {
      if ($("#pay_bill_item_" + this.value).text() == "已收") {
        url += "&item_ids[]=" + this.value;
        flag = true;
        sum_checked += 1;

      } else {
        hasNoPay = true;
      }
    }
  });

  if (hasNoPay) {
    alert("包含有未缴费项目,请先缴费再打印收据!");
    return;
  }
  if (!flag) {
    alert("至少选择一个收费项!");
    return;
  }

  if (sum_checked > 4) {
    alert("最多只能选择4项!");
    return;
  }
  var sFeatures = "height=600, width=810, top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=n o, status=no";
  window.open(url, '收据打印', sFeatures);
  setInterval(refresh_house, 5000);

}

function resetBill() {
  var house_code = $("#house_code").val();
  if (house_code == '') {
    alert("未选择房间");
    return;
  }
  var url = "<%=url_for(:controller => :bills, :action => :reset) %>";
  url += "?house_id=" + $('#house_id').val();
  var flag = false;
  $("input[name='pay_bill_item_ids']").each(function () {
    if (this.checked) {
      if ($("#pay_bill_item_" + this.value).text() == "已收") {
        url += "&bill_item_ids[]=" + this.value;
        flag = true;
      }
    }
  });


  if (!flag) {
    alert("至少选择一个收费项!");
    return;
  }
  $.post(url, function (data) {
    if (data.result == 'success') {
      alert(data.msg);
      refresh_house();
    }
  });
}

function receipt_show(receipt_no) {
  var url = "<%= url_for(:controller => :receipt, :action => :show) %>";
  url += "?receipt_no=" + receipt_no;
  var sFeatures = "height=600, width=810, top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=n o, status=no";
  window.open(url, '收据打印', sFeatures);
}

function search_house() {
  var house_code = $("#search_house_code").val();
  refresh_house(house_code);
  $("#house_code").val(house_code);
//        var treeObj = $.fn.zTree.getZTreeObj("house_tree");
//        var node = zTree1.getNodesByParam("name", house_code, null); // 仅查找一个节点
//        alert(node);
//        if (node.length>0) {
//            zTree1.expandNode(node[0], true, true, true);
//        } else {
//            zTree1.expandAll(true);
//        }
}

$(document).ready(function () {
  $("#start_time").datetimepicker();
  $("#end_time").datetimepicker();
});

