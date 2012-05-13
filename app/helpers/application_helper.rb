module ApplicationHelper

  def watch_image(watch)
    if watch.image_attachments.size > 0
      image_path watch.image_attachments[0].image.url(:thumb)
    else
      'NO IMAGE'
    end
  end
end
