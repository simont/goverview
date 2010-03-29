# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
   def obscure_email(email)
      return nil if email.nil? #Don't bother if the parameter is nil.
      lower = ('a'..'z').to_a
      upper = ('A'..'Z').to_a
      email.split('').map { |char|
        output = lower.index(char) + 97 if lower.include?(char)
        output = upper.index(char) + 65 if upper.include?(char)
        output ? "&##{output};" : (char == '@' ? '&#0064;' : char)
        }.join
    end
    
    

    # application_helper.rb
    def title(page_title)
      content_for(:title) { page_title }
    end

  
end
