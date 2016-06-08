#!/usr/bin/env ruby
file_path = ARGV[0]


def make_report(path)
  # given a folder path ie Volume
  dir_to_watch_name = Pathname.new(path)

  # for validation porpoused can use
  # puts "Initial checks"
  # puts "Is a directory: #{dir_to_watch_name.directory?}"
  # puts "Does it exists: #{dir_to_watch_name.exist?}"
  # puts "Is it readable: #{dir_to_watch_name.readable?}"
  # puts "-"*50

  sample_allowed=[".mp3",".wav",".prproj"]

  open_finder = false
  open_premiere = false


  @results =[]

  ##
  # helper method
  # Takes in the directory you want to look into
  # and an array of file types you want to search against
  # returns array of files it has found
  ##
  def find_file(dir_to_search,file_types)
    matched_files = []

    Find.find(dir_to_search) do |path|
      # matched_files << path if path =~ /.*\.mp3$/
      matched_files << path if  file_types.include? File.extname(path)
    end

    return matched_files
  end


  ##
  # Gathering all the projects on the system
  ##
  dir_to_watch_name.children.each do |project|
    # looking inside of projects folder such as "ASSETS", "MEDIA" etc..
   if(project.directory?)
     Project.new(project)
   end
  end

  ##
  # Iterate over instances of projects to find audio and video projects files
  ##
  Project.all.each do |project|
    project.get_path.children.each do |element |
      #Looking for Project files ANYWHERE inside project folder
      if(find_file(element,Project::ProjectFile.file_types) != [] )
        project_file_path =  find_file(element,Project::ProjectFile.file_types)
        # find_file returns array of all files it found, so we want to save them out at a time
        project_file_path.each do |p_file|
          project_file = Project::ProjectFile.new(p_file)
          project.add_project_file(project_file)
        end

      end
      #Looking for Audio_Files
      if(find_file(element,Project::AudioFile.file_types)!=[])
        audio_file_path =  find_file(element,Project::AudioFile.file_types)
        # find_file returns array of all files it found, so we want to save them out at a time
        audio_file_path.each do |a_file|
          audio_file = Project::AudioFile.new(a_file)
          project.add_audio_file(audio_file)
        end
        # puts audio_file.inspect
      end

    end
  end

  ##
  # Generating report
  ##
  Project.generate_report

  # resetting report class
  Project.clear_instances

end
##########################################################################################
############################## SEPARATE FILE  ############################################
##########################################################################################

#!/usr/bin/env ruby
# https://robm.me.uk/ruby/2014/01/18/pathname.html
require "pathname"
require "find"


# path_to_folder_containing_project_folders = "./Volume"
################################################################################################################
##
# Domain modelling into 3 classes, a Project, a ProjectFile, and a AudioFile to help with separation of concerns and keep track of attributes
# The Project class keeps a list of all the projects, array @@instances
# also keeps tracks of @audio_files and @project_files for each instance
# While ProjectFile and AudioFile are mainly storing path of the files
# common features of these two classes have been abstracted in FileElement class to avoid repetition
##
class Project
  @@count = 0
  @@instances = []
  @@date_formatting = "%Y-%h-%d__%H-%M-%S"

  @@destination = "#{ENV['HOME']}/Desktop"

  def initialize(path)
    @@count += 1
    @@instances << self

    @name = File.basename(path)
    @path = path

    @audio_files =[]
    @project_files=[]
    # default, does not have thsese files until they are added
    @audio_files_status = false
    @project_files_status = false

    @date = File.mtime(path)
  end

  def set_report_destination(path)
    @@destination = path
  end

  def self.all
    @@instances
  end

  def self.clear_instances
    @@instances =[]
  end

  def self.count
    @@count
  end

  def get_name
    return @name
  end

  def get_path
    return @path
  end


  def set_folder_structure_status(bool)
    @correct_folder_structure = bool
  end


  def has_folder_structure_status?
      @correct_folder_structure
  end


  def set_audio_files_status(bool)
    @audio_files_status = bool
  end

  def has_audio_files?
    @audio_files_status
  end

  def set_project_files_status(bool)
    @project_files_status = bool
  end

  def has_project_files?
    @project_files_status
  end

  def add_audio_file(audio_file)
    @audio_files <<audio_file
    @audio_files_status = true
  end

  def get_audio_files
    @audio_files
  end

  def add_project_file(file)
    @project_files <<file
    @project_files_status = true
  end

  def get_project_files
    @project_files
  end

  def get_modfied_date
    @date
  end

  def get_formatted_date
    get_modfied_date.strftime(@@date_formatting)
  end
  # Organised projects by creation date the project folder
  def self.ordered_instances
    @@instances.sort_by{|k| k.get_modfied_date}
  end


  def ordered_audio_instances
    @audio_files.sort_by{|k| k.get_modfied_date}
  end

  def ordered_project_instances
    @project_files.sort_by{|k| k.get_modfied_date}
  end


  def self.generate_report
    result = []
    title = "Media Report_"+ Time.now.strftime(@@date_formatting)
    result << title
    result << "\n"
    self.ordered_instances.each do |i|
      # puts "Project Name: " + i.get_name.to_s
      result << "Project Name: #{i.get_name}"
      # puts i.get_formatted_date
      result << "Date: #{i.get_formatted_date}"
      # puts "Project Path: "+i.get_path.to_s
      result << "Project Path: #{i.get_path}"

      if(i.has_project_files?)
        result << " "
          result << "Project files: "
        # puts "Project files: "
          i.get_project_files.each do|p_file|
            result << p_file.get_path
            # puts   p_file.get_path

        # i.ordered_project_instances.inspect
        end
      else
        result << "project files are missing from this project"
        # puts "project files are missing from this project"
      end

      if(i.has_audio_files?)
        result <<  " "
        result << "Audio files: "
          # puts "Audio files: "
          i.get_audio_files.each do |a_file|
              result <<  a_file.get_path
            # puts   a_file.get_path
          end
      else
            result << "audio files are missing from this project"
          # puts "audio files are missing from this project"
      end
      result << "\n "
      puts "\n "
    end
    puts result.join("\n")
    # Write report on user desktop
    # File.open("#{@@destination}/#{title}.txt", 'w') do |file|
    #   file.write(result.join("\n"))
    # end

  end

  class FileElement
      @file_types =[]
      @@date_formatting = "%Y-%h-%d %H:%M:%S"
    def initialize(path)
      @path = path
      @date = File.mtime(path)
    end

    def self.file_types
      @file_types
    end

    def get_path
      @path
    end

    def get_modfied_date
      @date
    end

    def get_formatted_date
      get_modfied_date.strftime(@@date_formatting)
    end
    # Organised projects by creation date the project folder
  end

  class AudioFile <FileElement
    # https://helpx.adobe.com/premiere-pro/using/supported-file-formats.html
    # TODO: needs checking with studio team list of audio files used in premiere projects
    @file_types =['.mp3','.wav','.m4a','.aac','.ac3','aiff','.aif ','.asnd','.avi','.bwf','.m4a','.mpeg','.mpg','.mov','.mxf','.wma']
  end

  class ProjectFile <FileElement
    #TODO: check if .aep should be after effects
    @file_types =['.prproj','.ppj','.aep']

  end
end
################################################################################################################


make_report(file_path)
