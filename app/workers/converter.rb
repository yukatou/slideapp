#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

SUCCESS_CODE = 200
ERROR_CODE = -100
THUMBNAIL_SIZE = 100
IMAGE_SIZE = 720

class Converter
  @queue = :converter

  def self.perform(slide_id)
    java = Constants.java
    convert = Constants.convert
    jodconverter = Constants.jodconverter
    
    begin 
      slide = Slide.find(slide_id)
      origin = '%s/public/%s/%s' % [Rails.root, slide.path, slide.origin]
      plog "#{slide.id}  #{origin}" 

      raise unless File.exists?(origin)

      convert_file = '%s/public/%s/%d.pdf' % [Rails.root, slide.path, slide.id]
      image_files = '%s/public/%s/%s' % [Rails.root, slide.path, '%03d.jpg']
      thumbnail_files = '%s/public/%s/%s' % [Rails.root, slide.path, '%03d_thm.jpg']
      glob_file = '%s/public/%s/%s' % [Rails.root, slide.path, '*_thm.jpg']

      # convert ppt
      plog "#{java} -jar #{jodconverter} #{origin} #{convert_file}"
      res = system("#{java} -jar #{jodconverter} #{origin} #{convert_file}")
      plog res

      # convert thumbnail 
      plog "#{convert} -density 600 -geometry #{THUMBNAIL_SIZE} #{convert_file} #{thumbnail_files}"
      res = system("#{convert} -density 600 -geometry #{THUMBNAIL_SIZE} #{convert_file} #{thumbnail_files}")
      plog res
      
      # convert image
      plog "#{convert} -density 600 -geometry #{IMAGE_SIZE} #{convert_file} #{image_files}"
      res = system("#{convert} -density 600 -geometry #{IMAGE_SIZE} #{convert_file} #{image_files}")
      plog res
      

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
        f.puts str
      end
  end

end
