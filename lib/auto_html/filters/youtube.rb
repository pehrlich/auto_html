AutoHtml.add_filter(:youtube).with(:width => 420, :height => 315, :frameborder => 0, :wmode => nil) do |text, options|
  regex = /(https?):\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/)([A-Za-z0-9_-]*)(\&\S+)?.*/
  text.gsub(regex) do
    protocol = $1
    youtube_id = $4
    width = options[:width]
    height = options[:height]
    frameborder = options[:frameborder]
		wmode = options[:wmode]
		src = "#{protocol}://www.youtube.com/embed/#{youtube_id}"
		src += "?wmode=#{wmode}" if wmode
    %{<div class="youtube well"><iframe width="#{width}" height="#{height}" src="#{src}" frameborder="#{frameborder}" allowfullscreen></iframe></div>}
  end
end

