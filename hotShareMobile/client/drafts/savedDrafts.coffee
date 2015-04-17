if Meteor.isClient
  Template.allDrafts.helpers
    items:()->
      for i in [0..SavedDrafts.find().count()-1]
        SavedDrafts.find({},{sort: {createdAt: -1}}).fetch()[i]
  Template.allDrafts.events
    'click .back':(event)->
        PUB.back()
    'click .rightButton':(event)->
        SavedDrafts
          .find {owner: Meteor.userId()}
          .forEach (saveddrafts)->
            SavedDrafts.remove saveddrafts._id
        PUB.back()
    'click .mainImage':(e)->
      #Clear draft first
      Drafts
        .find {owner: Meteor.userId()}
        .forEach (drafts)->
          Drafts.remove drafts._id
      #Prepare data
      savedDraftData = SavedDrafts.find({_id: @_id}).fetch()[0]
      #console.log "savedDraftData ="+JSON.stringify(savedDraftData)
      pub = savedDraftData.pub;
      if device.platform is 'Android'
        pub.index = -1

        FinalProcess = () ->
          Session.set 'isReviewMode','1'
          $('.user').addClass('animated ' + animateOutLowerEffect);
          Meteor.setTimeout ()->
            PUB.page('/add')
          ,animatePageTrasitionTimeout

        Dispatch = ()->
          if ++pub.index >= pub.length
            return FinalProcess()
          if pub[pub.index].type is 'image' && (pub[pub.index].URI.indexOf('file:///') >= 0)
            filename = pub[pub.index].filename
            URI = pub[pub.index].URI
            getBase64OfImage(filename,'',URI,ProcessImage)
          else
            ProcessText()

        ProcessText = ()->
  # must text
          Drafts.insert(pub[pub.index])
          Dispatch()

        ProcessImage = (URI,smallImage)->
          if smallImage
            console.log "pub index: " + pub.index
            pub[pub.index].imgUrl = smallImage
            Drafts.insert(pub[pub.index])
          else
            console.log ">>>>can't get base64"
            pub[pub.index].imgUrl = '/userIOS.png'
            Drafts.insert(pub[pub.index])
          #it was deleted
          Dispatch()

        Dispatch()


      else
          for i in [0..(pub.length-1)]
            Drafts.insert(pub[i])
          Session.set 'isReviewMode','1'
          PUB.page('/add')
      return
