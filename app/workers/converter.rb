#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

SUCCESS_CODE = 200
ERROR_CODE = -100
JAVA = '/usr/java/latest/bin/java'
CONVERT = '/usr/bin/convert'

class Converter
  @queue = :converter

  def self.perform(slide_id)
    
    slide = nil

    begin 
      slide = Slide.find(slide_id)
      file = Rails.root + '/' + slide.path + '/' + slide.origin
      path = File.expand_path("log/echo.log", Rails.root)
      File.open(path, 'a') do |f|
        f.puts "#{slide.id} #{file}" 
      end
      raise unless File.exists?(file)

      convert_file = slide.path + '/' + slide.id + '.pdf' 
      image_files = slide.path + '/' + '%03d.jpg'

      File.open(path, 'a') do |f|
        f.puts "#{JAVA} -jar /home/yukatou/src/jodconverter-core-3.0-beta-4/lib/jodconverter-core-3.0-beta-4.jar #{file} #{convert_file}"
      end
      exec("#{JAVA} -jar /home/yukatou/src/jodconverter-core-3.0-beta-4/lib/jodconverter-core-3.0-beta-4.jar #{file} #{convert_file}")

      File.open(path, 'a') do |f|
        f.puts "#{CONVERT} -density 600 -geometry 640 #{convert_file} #{image_files}"
      end
      exec("#{CONVERT} -density 600 -geometry 640 #{convert_file} #{image_files}")
      
      File.open(path, 'a') do |f|
        f.puts "#{slide.id} end" 
      end

      slide.update_attributes(:status => SUCCESS_CODE)
    rescue => e
      slide = Slide.find(slide_id)
      slide.update_attributes(:status => ERROR_CODE)
    end
  end

  def success(slide_id)
    Slide.find(slide_id)
  end
end
