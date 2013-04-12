// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ztree.core-3.0.min
//= require jquery.ztree.excheck-3.0.min
//= require jquery.ztree.exedit-3.0.min
//= require bootstrap.min
//= require bootstrap-datetimepicker.min
//= require bootstrap-datetimepicker.zh-CN


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

$.fn.datetimepicker.dates['zh-CN'] = {
                days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
            daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
            daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
            months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            today: "今日",
        suffix: [],
        meridiem: []
    };