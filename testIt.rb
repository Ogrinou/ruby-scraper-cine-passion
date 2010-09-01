#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$:.unshift 'lib'
require 'cine_passion'
require 'cine_passion_config'
require 'nfo'

search=ARGV[0]||"la cité de la peur"


testIt = CinePassion.new(@apikey)
testIt.Scrap(search)
if (testIt.result_nb > 1 )
	index = 1
	testIt.movies_info.each do |m|
		title_and_year="#{m['title']} (#{m['year']})"
		puts "#{index}. #{title_and_year}"
		index+=1
	end
	
	printf("Veuillez indiquer l'indice du titre attendu: ")
	begin
	while ((movie_index = (STDIN.gets.chomp().to_i)) == 0)
		puts "Veuillez entrer un nombre. "
	end
	rescue 
		puts "\nReçu : /#{$_}/"
		exit
	end
	movie_index = movie_index - 1
	movie = testIt.movies_info[movie_index]
else 
	movie = testIt.movies_info.first 
end

stream_xml = testIt.ScrapAnalyseOneMovieById(movie["id"])

nfo = Nfo.new(stream_xml)
puts nfo.pretty()

