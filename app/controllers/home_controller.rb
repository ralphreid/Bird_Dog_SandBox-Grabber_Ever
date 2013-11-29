class HomeController < ApplicationController
  def index
    @hello = "Ralph Mon"

    url = "http://www.anscombes.co.uk/properties/highgate-property/conversion-4-bedroom-flat-apartment-for-sale/1364288/shepherds-hill-highgate-n6?area=n4+2lx&longitude=&latitude=&radius=5&saleType=Sale"
    property = PropertyUkGrabber.get_property(url)
    @price = property.price


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
    @list = notes.notes.map { |n| {:title => n.title, :url => n.attributes.sourceURL} }


  end
end
