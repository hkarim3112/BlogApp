Trix.config.attachments.preview.caption = {
  name: false,
  size: false
};

document.addEventListener('trix-attachment-add', function (event) {
  const maxFileSize = 1024 * 1024 // 1MB
  const acceptedTypes = ['image/jpeg', 'image/png']
  var file = event.attachment.file;
  if (file) {
    if ( file.size > maxFileSize ) {
      event.attachment.remove();
      alert(file.size/1048576+" MBs too large");
      return false;
    }
    if ( !acceptedTypes.includes(file.type) ) {
      event.attachment.remove();
      alert(file.type+" file type is not allowed");
      return false;
    }
    var upload = new window.ActiveStorage.DirectUpload(file,'/rails/active_storage/direct_uploads');
    upload.create((error, attributes) => {
      if (error) {
        return false;
      } else {
        return event.attachment.setAttributes({
          url: `http://${location.host}/rails/active_storage/blobs/${attributes.signed_id}/${attributes.filename}`,
          href: `http://${location.host}/rails/active_storage/blobs/${attributes.signed_id}/${attributes.filename}`,
          width: `650`,
          height: `650`,
        });
      }
    });
  }
});
