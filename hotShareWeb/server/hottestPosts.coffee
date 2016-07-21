
Meteor.startup ()->
  hottestPosts=[]
  caleHottestPosts=()->
    hottestPosts=[]
    latestPost = new Date()
    latestPost.setHours(latestPost.getHours() - 48)
    latestPost = latestPost.getTime()

    latestView = new Date()
    latestView.setHours(latestView.getHours() - 24)
    latestView = latestView.getTime()

    queryString = "MATCH (u:User)-[v:VIEWER]->(p:Post) WITH v,p,length(()--p) AS views WHERE v.by > #{latestView} AND views > 50 AND p.createdAt > #{latestPost}  RETURN DISTINCT p.postId,p,length(()--p) AS views  ORDER BY views DESC LIMIT 5"
    queryResult = Neo4j.query queryString
    console.log queryString
    if queryResult and queryResult.length > 0
      queryResult.forEach (item)->
        postId=item[0]
        postInfo=item[1]
        postViews=item[2]
        console.log('postViews: '+postViews+' PostInfo '+JSON.stringify(postInfo))
        if postInfo and postInfo.postId and postInfo.name
          postInfo.views = postViews
          postInfo.hasPush = false
          hottestPosts.push(postInfo)

  @getHottestPosts=()->
    if(hottestPosts.length > 0)
      # 查找此故事是否推荐过，后面直接在neo4j里计算会更好
      # console.log('================');
      Posts.find({_id: {$in: _.pluck(hottestPosts, 'postId')}}, {fields: {hasPush: 1}}).forEach (item)->
        index = _.pluck(hottestPosts, 'postId').indexOf(item._id) 
        if index != -1
          hottestPosts[index].hasPush = item.hasPush
      # console.log(JSON.stringify(hottestPosts));
  
    if hottestPosts and hottestPosts.length > 0
      return hottestPosts
    else
      return null
  Meteor.setInterval caleHottestPosts,60*60*1000
  caleHottestPosts()
  
Meteor.methods({
  getHottestPosts: ()->
    return getHottestPosts()
})