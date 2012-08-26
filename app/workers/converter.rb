#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

SUCCESS_CODE = 200
ERROR_CODE = -100

class Converter
  @queue = :converter

  def self.perform(slide_id)
    
    begin 
      plog Constants.java 
      java = Constants.java
      convert = Constants.convert
      jodconverter = Constants.jodconverter
      density = Constants.image.density
      thumbnail_size = Constants.image.thumbnail_size
      image_size = Constants.image.size

      slide = Slide.find(slide_id)
      origin = '%s/public/%s/%s' % [Rails.root, slide.path, slide.origin]
      plog "#{slide.id}  #{origin}" 

      raise unless File.exists?(origin)

      convert_file = '%s/public/%s/%d.pdf' % [Rails.root, slide.path, slide.id]
      image_files = '%s/public/%s/%s' % [Rails.root, slide.path, '%03d.jpg']
      thumbnail_files = '%s/public/%s/%s' % [Rails.root, slide.path, '%03d_thm.jpg']
      glob_file = '%s/public/%s/%s' % [Rails.root, slide.path, '*_thm.jpg']

      # convert ppt
      command = "#{java} -jar #{jodconverter} #{origin} #{convert_file}"
      plog command
      plog system(command)

      # convert thumbnail 
      command = "#{convert} -density #{density} -geometry #{thumbnail_size} #{convert_file} #{thumbnail_files}"
      plog command
      plog system(command)
      
      # convert image
      command = "#{convert} -density #{density} -geometry #{image_size} #{convert_file} #{image_files}"
      plog command
      plog system(command)
      
      max = Dir::glob(glob_file).count
      for order in (1 .. max) do
        filename = '%03d.jpg' % [order - 1]
        thm_filename = '%03d_thm.jpg' % [order - 1]

        Page.create!(
          :filename => filename,
          :thm_filename => thm_filename,
          :order => order,
          :slide_id => slide.id
        )
      end 
      slide.update_attributes(:status => SUCCESS_CODE)
      plog "#{slide.id} end" 
    rescue => e
      plog e.message
      slide = Slide.find(slide_id)
      slide.update_attributes(:status => ERROR_CODE)
    end
  end

  def self.plog(str)
      path = File.expand_path("log/convert.log", Rails.root)
      File.open(path, 'a') do |f|
        f.puts "[%s] %s" % [Time.now, str]
      end
  end

end
