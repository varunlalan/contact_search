class HomeController < ApplicationController
  def index
  end

  def search_contacts
    search_param = params.require(:search_text)
    @obj = SearchContact.new(search_param)
    render_contacts(@obj.search)
  end

  private

  def render_contacts(results)
    render(
      json: results,
      each_serializer: ContactSerializer,
      adapter: :json,
      root: 'contacts',
      meta: {
        name_regex: @obj.instance_variable_get('@name_regex'),
        phone_regex: @obj.instance_variable_get('@phone_regex')
      },
      meta_key: 'regex'
    )
  end
end
