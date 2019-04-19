# ##########################################################################################
# Upwork freelanceer profile search according to keyword provided,
# Done using a single page script which can be later broken down in to its own class and actions
# For now kept it simple as i am switching to Ruby(just one day old :) )
# Logger used to log stdio
#

require 'rubygems'
require 'Selenium-webdriver'
require_relative 'log'

Dir[File.join(__dir__, '..', '*.rb')].each(&method(:require))

class SearchFreeLancerOpen




#------------------------------------------------------------------------------------------#
#                                  +Constants+                                             #
#------------------------------------------------------------------------------------------#


  ENV['BROWSER'] = 'firefox'
  ENV['URL'] = 'https://upwork.com'
  String keyword = "testing"
  SEARCH_TITLE = []
  SEARCH_NAME = []
  SEARCH_SKILLS = []
  SEARCH_DESCRIPTION = []
  SEARCH_SKILLS_COMBINED = []
  Agency_Skill_Value=[]
  Freelancer_Skill_Value=[]
  Agency_Skills_Array = Array.new
  Freelancer_Skills_Array = Array.new


#------------------------------------------------------------------------------------------#
#      +setting+driver+location+and+choosing+driver+type+based+on+variable+                #
#------------------------------------------------------------------------------------------#


  Selenium::WebDriver::Firefox.driver_path = File.expand_path('../Driver/geckodriver',__dir__ )
  Selenium::WebDriver::Chrome.driver_path = File.expand_path('../Driver/chromedriver',__dir__ )

  Options = Selenium::WebDriver::Firefox::Options.new
  Options.add_argument('--allow-running-insecure-content')
  Options.add_argument('--account-consistency')
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--allow-running-insecure-content')
  options.add_argument('--account-consistency')
  case ENV['BROWSER']
  when 'chrome'
    driver = Selenium::WebDriver.for :chrome, options: options

  when 'firefox'
    driver = Selenium::WebDriver.for :firefox
  end

#------------------------------*****END*****-----------------------------------------------#


#------------------------------------------------------------------------------------------#
#                        +Locators++Search++Result+                                        #
#------------------------------------------------------------------------------------------#

    i=1
    FIND_FREELANCER_INPUT = "(//*[@placeholder='Find Freelancers'])[3]"
    SEARCH_MAGNIFYING_GLASS = "(//*[@class='btn p-0-left-right'])[3]"
    SEARCH_RESULT_LOCATOR = '//section[@data-compose-log-data]['
    PROFILES = '//section[@data-compose-log-data]'
    FREELANCER_NAME_SEARCH = '//div[contains(@class,"ellipsis")]//h4'
    FREELANCER_TITLE_SEARCH = '//div[contains(@class,"m-0-top-bottom")][not(contains(@class,"ellipsis"))]//h4'
    FREELANCER_DESCRIPTION_SEARCH = '//div[contains(@class,"d-lg-block")]//p'
    FREELANCER_SKILLS_SEARCH = '//a[contains(@class,"o-tag-skill")]/span'
    FREELANCER_PROFILE_LINK = '//div[contains(@class,"ellipsis")]//h4/a'
#------------------------------------------------------------------------------------------#
#                            +Locators++Profile+                                           #
#------------------------------------------------------------------------------------------#


    FREELANCER_OR_COMPANY = '(//h3[@class="title "])[2]'
    FREELANCER_NAME_PROFILE = '//div[contains(@class,"air-card")]//div[@class="media"]//h2'
    AGENCY_NAME = '//div[@class="row"]//div[@class="media"]//h2'
    FREELANCER_TITLE = '//div[@class="overlay-container"]//h3'
    AGENCY_TITLE = '//div[contains(@class,"air-card")]//h3[@ng-if="vm.profile.title"]'
    FREELANCER_DESCRIPTION = '//o-profile-overview[@words=80]//p'
    AGENCY_DESCRIPTION = '//div[contains(@class,"air-card")]//div[@o-text-truncate]'
    FREELANCER_SKILLS = '//div[contains(@class,"o-profile-skills")]/a'
    ALERT_WARNING = '//div[@class="container"]//div[@type="warning"]'

#------------------------------------------------------------------------------------------#
#                                +Locators+End+                                            #
#------------------------------------------------------------------------------------------#



#------------------------------------------------------------------------------------------#
#                                +Start+Execution+                                         #
#------------------------------------------------------------------------------------------#

# [1] Run `<browser>`
  Log.step("*******************************")
  Log.step("[1] Run `<browser>`")
  Log.step("*******************************")
  driver.manage.window.maximize

# [2] Clear `<browser>` cookies
  Log.step("*******************************")
  Log.step("[2] Clear `<browser>` cookies")
  Log.step("*******************************")
  driver.manage.delete_all_cookies
  Log.done

# [3] Go to www.upwork.com
  Log.step("*******************************")
  Log.step("[3] Go to www.upwork.com")
  Log.step("*******************************")

  Log.step("Opening Upwork")
  driver.navigate.to ENV['URL']
  puts 'Upwork is loaded in '+ ENV['BROWSER'] +' browser'
  Log.done(ENV['URL'] + " Loaded")


# [4] Focus onto "Find freelancers"
  Log.step("*******************************")
  Log.step("[4] Focus onto 'Find freelancers'")
  Log.step("*******************************")

  mainPageSearch = driver.find_element(:xpath,FIND_FREELANCER_INPUT)
  Log.step("Focusing on the SearchBox")
  mainPageSearch.click

# [5] Enter `<keyword>` into the search input right from the dropdown
# and submit it (click on the magnifying glass button)

  Log.step("*******************************")
  Log.step("[5] Enter `<keyword>` into the search input right from the dropdown and submit it (click on the magnifying glass button)")
  Log.step("*******************************")
  Log.step("Send keyword in SearchBox")
  mainPageSearch.send_key(keyword)
  searchEnter = driver.find_element(:xpath,SEARCH_MAGNIFYING_GLASS)
  Log.step("Click on Magnifying icon")
  searchEnter.click

# [6] Parse the 1st page with search results:
# store info given on the 1st page of search results as structured data of any chosen by you type

  Log.step("*******************************")
  Log.step("[6] Parse the 1st page with search results:")
  Log.step("*******************************")
  searchPageProfileContent= Array.new
  profiles = driver.find_elements(:xpath,PROFILES)
  profile_index = profiles.length
  while i <= profile_index do
    # Fetch Freelancer name
    Search_Page_Freelancer_Name = driver.find_element(:xpath,SEARCH_RESULT_LOCATOR + i.to_s + ']'+ FREELANCER_NAME_SEARCH).text
    SEARCH_NAME[i] = Search_Page_Freelancer_Name
    # Fetch Freelancer Title
    Search_Page_Freelancer_Title = driver.find_element(:xpath,SEARCH_RESULT_LOCATOR + i.to_s + ']'+ FREELANCER_TITLE_SEARCH).text
    SEARCH_TITLE[i] = Search_Page_Freelancer_Title
    Log.step(i.to_s + " = "+SEARCH_TITLE[i])
    # Fetch Freelancer Description
    Search_Page_Freelancer_Desc = driver.find_element(:xpath,SEARCH_RESULT_LOCATOR + i.to_s + ']'+ FREELANCER_DESCRIPTION_SEARCH).text
    SEARCH_DESCRIPTION[i] = Search_Page_Freelancer_Desc
    # Fetch Freelancer Skills

    Search_Page_Freelancer_Skills = driver.find_elements(:xpath,SEARCH_RESULT_LOCATOR + i.to_s + ']'+ FREELANCER_SKILLS_SEARCH)
    search_page_skill_index = Search_Page_Freelancer_Skills.length
    j=1
    while j<=search_page_skill_index do
      SEARCH_SKILLS[j] = Search_Page_Freelancer_Skills[j].text unless Search_Page_Freelancer_Skills[j].nil?
      Log.step(SEARCH_SKILLS[j])
      j+=1
    end
    SEARCH_SKILLS_COMBINED[i] = SEARCH_SKILLS.to_s

# [7] Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer)
# from parsed search results contains `<keyword>` Log in stdout which freelancers and attributes contain `<keyword>` and which do not.

    Log.step("*******************************")
    Log.step("[7] Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer)")
    Log.step("*******************************")
    if (SEARCH_SKILLS.compact.map(&:downcase)).include?(keyword.downcase)
        if(Search_Page_Freelancer_Desc.downcase).include?(keyword.downcase)
          if(Search_Page_Freelancer_Title.downcase).include?(keyword.downcase)
            Log.done("\nKeyword Found in: \n" + Search_Page_Freelancer_Name + " In: Skills, Description and Title")
          else
            Log.done("\nKeyword Found in: \n" + Search_Page_Freelancer_Name + " In: Skills and Description")
          end
        else
          Log.done("\nKeyword Found in: \n" + Search_Page_Freelancer_Name + " In: Skills")
        end
    elsif (Search_Page_Freelancer_Desc.downcase).include?(keyword.downcase)
      if (Search_Page_Freelancer_Title.downcase).include?(keyword.downcase)
        Log.done("\nKeyword Found in: \n" + Search_Page_Freelancer_Name + " In: Description & Title")
      else
        Log.done("\nKeyword Found in: \n" + Search_Page_Freelancer_Name + " In: Description")
      end
    elsif (Search_Page_Freelancer_Title.downcase).include?(keyword.downcase)
      Log.done("\nKeyword Found in: \n" + Search_Page_Freelancer_Name + " In: Title")
    else
      Log.step("\nKeyword Not Found in: \n" + Search_Page_Freelancer_Name)
    end
    i+=1
  end

# [8] Click on random freelancer's title
  Log.step("*******************************")
  Log.step("[8] Click on random freelancer's title: ")
  Log.step("*******************************")
  FREELANCER_PROFILE_LINKS = driver.find_elements(:xpath,FREELANCER_PROFILE_LINK)
  index = FREELANCER_PROFILE_LINKS.length - 1
  random = rand(1..index).freeze
  FREELANCER_PROFILE_LINKS[random].click
  sleep 5
# [9] Get into that freelancer's profile

  Log.step("*******************************")
  Log.step("[9] Get into that freelancer's profile: ")
  Log.step("*******************************")

# [10] Check that each attribute value is equal to one of those stored in the structure created in #67 For AGENCY

  Agency_Or_Freelance = driver.find_element(:xpath,FREELANCER_OR_COMPANY).text
  if Agency_Or_Freelance.include?("agency")
    Log.step("*******************************")
    Log.step("[10] Check that each attribute value is equal to one of those stored in the structure created in #67 For Agency")
    Log.step("*******************************")
    Agency_Name = driver.find_element(:xpath,AGENCY_NAME).text
    Agency_Title = driver.find_element(:xpath,AGENCY_TITLE).text
    Agency_Description = driver.find_element(:xpath,AGENCY_DESCRIPTION).text

    if (Agency_Title).include?(SEARCH_TITLE[random+1])
      Log.done(Agency_Name + " Title Matched with search results\n")
    else
      Log.step("Title did not match with search results\n")
    end
    if (Agency_Name).include?(SEARCH_NAME[random+1])

      Log.done(Agency_Name + " Name Matched with search results\n")
    else
      Log.step("Name did not match with search results\n")
    end
    puts "Agency"
    if(Agency_Description.downcase).include?(SEARCH_DESCRIPTION[random+1].downcase)
      Log.done(Agency_Name + " Description Matched with search results\n")
    else
      Log.step("Description did not match with search results\n")
    end
    Agency_Skills = driver.find_elements(:xpath,FREELANCER_SKILLS)
    agency_skill_index = Agency_Skills.length
    k=0
    for skill in Agency_Skills
      Agency_Skills_Array[k] = skill.text.to_s unless skill.text.nil?
      k+=1
    end

            Agency_All_Skills = Agency_Skills_Array.to_s
            Search_Skills_String = SEARCH_SKILLS_COMBINED[random+1].to_s
          if Agency_All_Skills.include?Search_Skills_String
            Log.done("Skill Matched with skill on Search Page \n")
          else
            Log.step("Skill did not match with search page skills, may be the skill was in Freelancer's account \n")
          end
          k+=1


# [11] Check whether at least one attribute contains `<keyword>`
    Log.step("*******************************")
    Log.step("[11] Check whether at least one attribute contains `<keyword>`")
    Log.step("*******************************")

    Agency_Data=[Agency_Title, Agency_Name, Agency_Description, Agency_All_Skills].join(sep=$,)
    if Agency_Data.downcase.include?(keyword.downcase)

      Log.done("Agency contains keyword: " + keyword)
    else
      Log.step("Agency doesn't contains keyword: " + keyword)
    end
  else

# [10] Check that each attribute value is equal to one of those stored in the structure created in #67 For Freelancer
    Log.step("*******************************")
    Log.step("[10] Check that each attribute value is equal to one of those stored in the structure created in #67 For Freelancer")
    Log.step("*******************************")
    Freelancer_Name_Profile = driver.find_element(:xpath,FREELANCER_NAME_PROFILE).text
    Freelancer_Title = driver.find_element(:xpath,FREELANCER_TITLE).text
    Freelancer_Description = driver.find_element(:xpath,FREELANCER_DESCRIPTION).text

    if (SEARCH_DESCRIPTION[random+1].downcase).include?(Freelancer_Description.downcase)
    Log.done(Freelancer_Name_Profile + " Description Matched with search results\n")
    else
    Log.step("Description did not match with search results\n")

    end

    if (SEARCH_TITLE[random+1].downcase).include?(Freelancer_Title.downcase)
      Log.done(Freelancer_Name_Profile + " Title Matched with search results\n")
    else
      Log.step("Title did not match with search results\n")
    end
    if (SEARCH_NAME[random+1].downcase).include?(Freelancer_Name_Profile.downcase)
      Log.done(Freelancer_Name_Profile + " Name Matched with search results\n")
    else
      Log.step("Name did not match with search results\n")
    end

    Freelancer_Skills = driver.find_elements(:xpath,FREELANCER_SKILLS)
    skill_index = Freelancer_Skills.length
    l=0
    for skill in Freelancer_Skills
      Freelancer_Skill_Value = skill.text.to_s unless skill.text.nil?
      Freelancer_Skills_Array[l] = Freelancer_Skill_Value
      l+=1
    end

    #while l < skill_index do
     # puts Freelancer_Skills[l].text
     # Freelancer_Skill_Value = Freelancer_Skills[l].text.to_s unless Freelancer_Skills[l].text
     # Freelancer_Skills_Array[l] = Freelancer_Skill_Value
     # l+=1
    #end
    Freelancer_All_Skills = Freelancer_Skills_Array.to_s
    Search_Skills_String = SEARCH_SKILLS_COMBINED[random+1].to_s

    puts "***********SKILSS********"
    puts Freelancer_All_Skills
    puts Search_Skills_String
    puts "*************************"
      if Freelancer_All_Skills.include?(Search_Skills_String)
        Log.done("Skill Matched completely with skill on Search Page \n")
      else
        Log.step("Skill did not match completely with search page skills \n")
      end

# [11] Check whether at least one attribute contains `<keyword>`
    Log.step("*******************************")
    Log.step("[11] Check whether at least one attribute contains `<keyword>`")
    Log.step("*******************************")


   Freelancer_Data = [Freelancer_Title,Freelancer_Name_Profile,Freelancer_Description, Freelancer_All_Skills].join(sep=$,)
    if Freelancer_Data.downcase.include?(keyword.downcase)
      Log.done("Freelancer contains keyword: " + keyword)
    else
      Log.step("Freelancer doesn't contains keyword: " + keyword)
    end

end
  driver.quit

  Log.publish_results

end

#------------------------------------------------------------------------------------------#
#                                +End+Execution+                                         #
#------------------------------------------------------------------------------------------#