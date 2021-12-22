
ActiveSupport.on_load :action_view do
  # will_paginate сразу и определяет класс и подгружает его в actionview, поэтому приходится наследоваться в колбеке
  WillPaginate::ActionView::LinkRenderer.prepend(BootstrapLinkRenderer)
end
