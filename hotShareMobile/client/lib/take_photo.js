if (Meteor.isCordova) {
  function replaceAll(find, replace, str) {
    return str.replace(new RegExp(find, 'g'), replace);
  }
  window.takePhoto = function(callback){
    var pictureSource = navigator.camera.PictureSourceType;
    var destinationType = navigator.camera.DestinationType;

    navigator.camera.getPicture(function (imageURI) {
      //var returnURI = imageURI;
      var timestamp = new Date().getTime();
      var retVal = {filename:'', URI:'', smallImage:''};
      retVal.filename = Meteor.userId()+'_'+timestamp+ '_'+imageURI.replace(/^.*[\\\/]/, '');
      retVal.URI = imageURI;
      //ios "file:///var/mobile/Containers/Data/Application/748449D2-3F45-4057-9630-F12065B1C0C8/tmp/cdv_photo_002.jpg"
      console.log('image uri is ' + imageURI);
      retVal.smallImage = 'cdvfile://localhost/temporary/' + imageURI.replace(/^.*[\\\/]/, '');
      if(callback){
        callback(retVal);
      }
    }, function(){
      console.log('take photo failed');
      if(callback){
        callback(null);
      }
    }, { quality: 1,
    destinationType: destinationType.FILE_URI,
    sourceType: pictureSource.CAMERA,
    targetWidth: 2000,
    targetHeight: 2000,
    correctOrientation: true,
    saveToPhotoAlbum: false});
  }
}
