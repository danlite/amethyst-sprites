Paperclip.interpolates('pokemon') do |attachment, style|
  p = attachment.instance.series.pokemon
  [p.dex_number, p.full_name].join(" ").parameterize
end