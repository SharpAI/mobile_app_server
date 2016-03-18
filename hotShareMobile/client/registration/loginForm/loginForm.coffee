Template.loginForm.events
    'click #btn_back' :->
#      Router.go '/authOverlay'
      $('.login').css('display',"none")
      $('#register').css('display',"block")
      $('#weibo').css('display',"block")
      $('#login').css('display',"block")
      $('.recovery').css('display',"none")
#      $('.authOverlay').css('-webkit-filter',"none")
    'click .forgetPassword' :->
      $('.login').css('display',"none")
      $('#register').css('display',"none")
      $('#weibo').css('display',"none")
      $('#login').css('display',"none")
      $('.recovery').css('display',"block")
      $('.agreeDeal').css('display',"none");
    'submit #login-form':(e,t)->
      e.preventDefault()
      if Meteor.status().connected isnt true
        PUB.toast '当前为离线状态,请检查网络连接'
        return
      name = t.find('#login-username').value
      Session.set 'userName',name
      pass = t.find('#login-password').value
      if name is '' or pass is ''
        return
      t.find('#sub-login').disabled = true
      t.find('#sub-login').value = '正在登录...'
      Meteor.loginWithPassword name, pass,(error)->
        if error
          PUB.toast '帐号或密码有误！'
          t.find('#sub-login').disabled = false
          t.find('#sub-login').value = '登 录'
        else
          Router.go '/'
          if Session.get('registrationID') is undefined and localStorage.getItem('registrationID') and device.platform is 'iOS'
            console.log( localStorage.getItem('registrationID'));
            window.updatePushNotificationToken('iOS', localStorage.getItem('registrationID'))
          return
      false 
Template.recoveryForm.events
    'click #btn_back' :->
      $('.login').css('display',"none")
      $('#register').css('display',"block")
      $('#weibo').css('display',"block")
      $('#login').css('display',"block")
      $('.recovery').css('display',"none")
    'submit #recovery-form':(e,t)->
      e.preventDefault()
      if Meteor.status().connected isnt true
        PUB.toast '当前为离线状态,请检查网络连接'
        return
      email = t.find('#recovery-email').value
      if email is ''
        return
      t.find('#sub-recovery').disabled = true
      t.find('#sub-recovery').value = '正在重设...'
      Accounts.forgotPassword {email:email},(error)->
        t.find('#sub-recovery').disabled = false
        t.find('#sub-recovery').value = '重设'
        if error
          if error.error is 403 and error.reason is 'User not found'
            PUB.toast '您填写的邮件地址不存在！'
          else
            PUB.toast '暂时无法处理您的请求，请稍后重试！'
        else
          #PUB.toast '请访问邮件中给出的网页链接地址，根据页面提示完成密码重设。'
          navigator.notification.confirm('请访问邮件中给出的网页链接地址，根据页面提示完成密码重设。', (r)->
            if r is 1
              $('#recovery-email').val('');
          , '提示信息', ['确定']);
          $('.login').css('display',"none")
          $('#register').css('display',"block")
          $('#weibo').css('display',"block")
          $('#login').css('display',"block")
          $('.recovery').css('display',"none")
