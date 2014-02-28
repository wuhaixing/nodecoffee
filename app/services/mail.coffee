nodemailer = require 'nodemailer'
env = process.env.NODE_ENV or 'development'
config = require('../../config/environment')[env]

mail = mail: 
  host: 'smtp.126.com'
  port: 25
  auth: 
    user: 'nodecoffee@126.com'
    pass: '4008801163'

smtpTransport = nodemailer.createTransport("SMTP",mail)

sendMail = (data)->
  	smtpTransport.sendMail data,(err)->
  		console.error(err) if err?

exports.sendActiveMail = (email,name,token)->

    html = "<p>#{name},您好：<p/>
        <p>我们收到您在 #{config.app.name} 的注册申请，请点击下面的链接激活帐户：</p>
        <a href='#{config.app.host}/account/active?token=#{token}&email=#{email}'>请点击本链接激活帐号</a>
        <p>若不是您本人发出的申请，可能是有人滥用了您的电子邮箱，请删除此邮件。对此造成的不便我们深感抱歉，希望您能谅解！</p>
        <p>#{config.app.name} 谨上。</p>"

    sendMail
        from: mail.auth.user
        to: email
        subject: "#{config.app.name}-帐号激活"
        html: html
