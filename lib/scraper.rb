require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))

    doc.css("div.student-card").each do |student|
      indiv_student = {
        :name => student.css("h4.student-name").text.strip,
        :location => student.css("p.student-location").text.strip,
        :profile_url => student.css("a").attr("href").value
      }
      students << indiv_student
    end

    students

  end

  def self.scrape_profile_page(profile_url)
    student_profile = {}
    doc = Nokogiri::HTML(open(profile_url))
    
    #collect all elements in the social icons/links container
    social_icons_container = doc.css("div.social-icon-container a")
    
    #return list of links for all sites in the social_links_container
    links = social_icons_container.collect {|icon| icon.attr("href")}

    #take the collection of links and assign them to the appropriate attribute for the student
    #if the links array only contains 2 links, only 2 will be assigned; if it contains 4, then all 4 are assigned
    links.each do |link|
      if link.include?("twitter")
        student_profile[:twitter] = link
      elsif link.include?("linkedin")
        student_profile[:linkedin] = link
      elsif link.include?("github")
        student_profile[:github] = link
      else
        student_profile[:blog] = link
      end
    end

    student_profile[:profile_quote] = doc.css("div.profile-quote").text.strip
    student_profile[:bio] = doc.css("div.bio-content p").text.strip

    student_profile #return the completed student profile
        
  end
end

    #---- approaches ---- 

    #pull the icon name, which can id social site type
    #icons = social_icons_container.collect {|icon_element| icon_element.children.attr("src").value}
      
    # if icons.include?(("../assets/img/twitter-icon.png")
    #   twitter_link = students_social_links.find {|link| link.include?("https://twitter.com")}
    # else
    #   twitter_link = "no link"
    # end
    
    # if icons.include?(("../assets/img/linkedin-icon.png")
    #   linkedin_link = students_social_links.find {|link| link.include?("https://linkedin.com")}
    # else
    #   linkedin_link "no link"
    # end

    # if icons.include?(("../assets/img/github-icon.png")
    #   github_link = students_social_links.find {|link| link.include?("https://github.com")}
    # else
    #   github_link "no link"
    # end

    # if icons.include?(("../assets/img/rss-icon.png")
    #   rss_link = students_social_links.find {|link| link.include?("https://github.com")}
    # else
    #   rss_link "no link"
    # end

    #twitter_link = students_social_links.find {|link| link.include?("https://twitter.com")} || "No link"
    #linkedin_link = students_social_links.find {|link| link.include?("https://linkedin.com")} || "No link"

    # student_profile = {
    #   :twitter => twitter_link,
    #   :linkedin => linkedin_link,
    #   :github => github_link,
    #   :blog => blog_link,
    # }
