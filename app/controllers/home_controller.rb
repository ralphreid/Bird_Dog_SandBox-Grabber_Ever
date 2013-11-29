class HomeController < ApplicationController
  def index
    


    authToken = ENV['EVERNOTE_DEV_TOKEN']
    evernoteHost = "sandbox.evernote.com"
    userStoreUrl = "https://#{evernoteHost}/edam/user"
    userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
    userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
    userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)
    noteStoreUrl = userStore.getNoteStoreUrl(authToken)
    noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
    noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
    noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)
    notebooks = noteStore.listNotebooks(authToken)

    notes = noteStore.findNotes(authToken, Evernote::EDAM::NoteStore::NoteFilter.new, nil, 100)
    @list = notes.notes.map { |n| {:title => n.title, :price => (PropertyUkGrabber.get_property(n.attributes.sourceURL)).price} }
    
    
    # property = PropertyUkGrabber.get_property(url)
    # @price = property.price


  end
end
