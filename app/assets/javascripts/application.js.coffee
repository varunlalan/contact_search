#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require handlebars
#= require_tree .


$(->

  $('#section1').height($('html').height() - $('#section2').height())

  Handlebars.registerHelper "drawInitial", (string) ->
    string[0]

  listContacts = Handlebars.compile($('#contacts_list').html())

  formRegex = ((regexStr) ->
    RegExp(regexStr, "gi")
  )

  highlightMatches = ((regex) ->
    nameRegex = regex.name_regex
    phoneRegex = regex.phone_regex

    $('li .name').each ((i, name) ->
      $firstName = $(name).find('.first_name')
      html = $firstName.html()
      $firstName.html(html.replace(formRegex(nameRegex), '<strong>$&</strong>'));

      $lastName = $(name).find('.last_name')
      html = $lastName.html()
      $lastName.html(html.replace(formRegex(nameRegex), '<strong>$&</strong>'));
    )

    $('li .phone_number').each ((i, phone) ->
      html = $(phone).html()
      $(phone).html(html.replace(formRegex(phoneRegex), '<strong>$&</strong>'));
    )
  )

  fetchContacts = ((searchText) ->
    $contactsList = $("#search_list ul")

    if searchText == ""
      $contactsList.html("")
    else
      $.ajax(
        url: "search_contacts", data: {search_text: searchText},
      ).done((data) ->
        $contactsList.html(listContacts(contacts: data.contacts))
        highlightMatches(data.regex)
      )
  )

  $("#keys .column").on('click', ->
    $searchTextField = $('#search_text_field #text')

    value         = $(@).data('show')
    searchText    = $searchTextField.text()
    newSearchText = searchText + value

    $searchTextField.text(newSearchText)
    fetchContacts(newSearchText)
  )

  $('#clear_image').on('click', ->
    $searchTextField = $('#search_text_field #text')
    searchText = $searchTextField.text()
    newSearchText = searchText.substring(0, searchText.length - 1)
    $searchTextField.text(newSearchText)
    fetchContacts(newSearchText)
  )
)
