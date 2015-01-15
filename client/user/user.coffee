#space 2
if Meteor.isClient
  Template.user.helpers
    followers:->
      #Follower存放用户间关注记录， Follows是推荐偶像列表
      #followerId是偶像userId, userId是粉丝userId
      Follower.find({"followerId":Meteor.userId()}).count()
    draftsCount:->
      SavedDrafts.find().count()
    compareDraftsCount:(value)->
      if (SavedDrafts.find().count() > value)
        true
      else
        false
    items:()->
      value = 0
      if SavedDrafts.find().count() >=2
        value = 1
      else
        value = SavedDrafts.find().count()-1
      for i in [0..value]
        SavedDrafts.find().fetch()[i]
    followCount:->
      Follower.find({"userId":Meteor.userId()}).count()
  Template.user.events
    'click .icon':(e)->
      val = e.currentTarget.innerHTML
      uploadFile (result)->
        e.currentTarget.innerHTML = '<span class="fa fa-spinner fa-spin"></span>'
        if result
          e.currentTarget.innerHTML = '<img src="'+result+'">'
          Meteor.users.update Meteor.userId(),{$set:{'profile.icon':result}}
          console.log '头像上传成功：' + result
        else
          e.currentTarget.innerHTML = val
        return
      return
    'click #setting' :->
      Router.go '/dashboard'
    'click .follower' :->
      #true 列出偶像列表，false 列出粉丝列表
      Session.set 'followers_tag', false
      Router.go '/followers'
    'click .following' :->
      #true 列出偶像列表，false 列出粉丝列表
      Session.set 'followers_tag', true
      Router.go '/followers'
#    'click #login-name-link' :->
#      document.getElementById('login-buttons-open-change-password').innerHTML = '修改密码'
#      document.getElementById('login-buttons-logout').innerHTML = '退出'
#      $("#login-dropdown-list .login-close-text").html "关闭"
#      return
#    'click #login-buttons-open-change-password':-> 
#      Meteor.setTimeout ->
#        document.getElementById('login-old-password-label').innerHTML = '当前密码'
#        document.getElementById('login-password-label').innerHTML = '更改密码'
#        document.getElementById('login-buttons-do-change-password').innerHTML = '修改密码'
#        0
#      return
    'click li':(e)->
      #Clear draft first
      Drafts
        .find {owner: Meteor.userId()}
        .forEach (drafts)->
          Drafts.remove drafts._id
      #Prepare data
      savedDraftData = SavedDrafts.find({_id: e.currentTarget.id}).fetch()[0]
      pub = savedDraftData.pub;
      for i in [0..(pub.length-1)]
          Drafts.insert(pub[i])
      Session.set 'isReviewMode','true'
      PUB.page('/add')
    'click .draftRight':(e)->
      PUB.page('/allDrafts')

