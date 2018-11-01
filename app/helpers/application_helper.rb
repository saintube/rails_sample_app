module ApplicationHelper

  # rendering the complete title according to the page info
  def full_title(page_title = '')                          # define a method
    base_title = "Ruby on Rails Tutorial Sample App"       # assign a value
    if page_title.empty?                                   # boolean test
      base_title                                           # return implicitly
    else
      page_title + " | " + base_title                      # build a string
    end
  end
end
