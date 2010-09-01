require 'rexml/document'
include REXML

# http://wiki.xbmc.org/index.php?title=Import_-_Export_Library#Video_nfo_Files

class Nfo
  attr_accessor :content
  def initialize(xml_string)
    doc = Document.new(xml_string)
    root= doc.root

    @content = Document.new
    @content.add_element("movie")
    movie = content.root
    movie.add_element("title").add_text(root.elements["title"].text.to_s.strip)

    movie.add_element("originaltitle").add_text(root.elements["originaltitle"].text.to_s.strip)
    movie.add_element("sorttitle").add_text("")
    movie.add_element("set").add_text("")
    movie.add_element("rating").add_text("")
    movie.add_element("year").add_text(root.elements["year"].text.to_s.strip)
    movie.add_element("top250").add_text("")
    movie.add_element("votes").add_text("")
    movie.add_element("outline").add_text(root.elements["plot"].text.to_s.strip)
    movie.add_element("plot").add_text(root.elements["plot"].text.to_s.strip)
    movie.add_element("tagline").add_text(root.elements["tagline"].text.to_s.strip)
    movie.add_element("runtime").add_text("#{root.elements["runtime"].text.to_s.strip} min")
    movie.add_element("thumb").add_text("")
    movie.add_element("mpaa").add_text(root.elements["information"].text.to_s.strip)
    movie.add_element("playcount").add_text("")
    movie.add_element("watched").add_text("false")
    movie.add_element("id").add_text(root.elements["id_imdb"].text.to_s.strip)
    movie.add_element("filenameandpath").add_text("")

    movie.add_element("trailer").add_text(joinElements(root.elements["trailers"],'trailer'))
    movie.add_element("genre").add_text(joinElements(root.elements["genres"],'genre',' / '))

    movie.add_element("credits").add_text(joinElements(root.elements['credits'],'credit'))

    movie.add_element("fileinfo").add_text("")

    movie.add_element("director").add_text(joinElements(root.elements['directors'],'director'))

    root.elements['casting'].each_element('person') { |e|
      tmp= movie.add_element("actor")
      tmp.add_element("name").add_text(e.attribute("name").to_s)
      tmp.add_element("role").add_text(e.attribute("character").to_s)
      tmp.add_element("thumb").add_text(e.attribute("thumb").to_s)
    }

  end


  def to_s()
    "#{@content.class} : #{@content.to_s}"
  end

  def pretty()
    result = ""
    format = REXML::Formatters::Pretty.new()
    format.compact=true
    format.write(@content,result)
    result
  end

  def write()
    @content.write($stdout)
  end

  private

  def joinElements(xmldoc, element_name, separator=", ")
    result=[]
    xmldoc.each_element(element_name) { |e|
      result.push e.text.to_s.strip
    }
    result.join(separator)
  end


end
