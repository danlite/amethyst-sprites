Paperclip.interpolates('pokemon') do |attachment, style|
  begin
    p = attachment.instance.series.pokemon
    [p.dex_number, p.full_name].join(" ").parameterize
  rescue
    'missingno'
  end
end