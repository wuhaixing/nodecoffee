(function(a){a.extend(a.validator.messages,{required:"必填字段",remote:"请修正该字段",email:"请输入格式正确的电子邮件",url:"请输入合法的网址",date:"请输入合法的日期",dateISO:"请输入合法的日期 (ISO).",number:"请输入合法的数字",digits:"只能输入整数",creditcard:"请输入合法的信用卡号",equalTo:"请输入相同的值",accept:"请输入拥有合法后缀名的字符串",maxlength:a.validator.format("请输入一个长度不超过 {0} 的字符串"),minlength:a.validator.format("请输入一个长度不少于 {0} 的字符串"),rangelength:a.validator.format("请输入一个长度介于 {0} 和 {1} 之间的字符串"),range:a.validator.format("请输入一个介于 {0} 和 {1} 之间的值"),max:a.validator.format("请输入一个最大为 {0} 的值"),min:a.validator.format("请输入一个最小为 {0} 的值")})})(jQuery)