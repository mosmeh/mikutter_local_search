# -*- coding: utf-8 -*-

Plugin.create :mikutter_local_search do
  loaded_messages = []

  querybox = ::Gtk::Entry.new()
  querycont = ::Gtk::VBox.new(false, 0)
  searchbtn = ::Gtk::Button.new('検索')

  querycont.closeup(::Gtk::HBox.new(false, 0)
           .pack_start(querybox)
           .closeup(searchbtn))

  tab(:local_search, "ローカル検索") do
    set_icon Skin.get("savedsearch.png")
    shrink
    nativewidget querycont
    expand
    timeline :local_search
  end

  on_appear do |messages|
    loaded_messages << messages
    loaded_messages.flatten!
  end

  querybox.signal_connect('activate'){|elm| searchbtn.clicked}

  searchbtn.signal_connect('clicked') do |elm|
    elm.sensitive = querybox.sensitive = false
    timeline(:local_search).clear
    if querybox.text == ''
      timeline(:local_search) << Message.new(:message => 'キーワードを指定してください', :system => true)
    else
      query = querybox.text.downcase
      timeline(:local_search) << loaded_messages.select do |message|
        message.to_s.downcase.include?(query)
      end
    end
    elm.sensitive = querybox.sensitive = true
  end
end
