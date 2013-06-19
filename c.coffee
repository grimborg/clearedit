class Editor
    hotkeys: {
        'ctrl+b meta+b': 'bold',
        'ctrl+u': 'insertunorderedlist'
        'ctrl+shift+m meta+shift+m': 'insertorderedlist'
    }
    constructor: (element) ->
        @element = element
    bindHotKeys: ->
        element = @element
        console.log(@hotkeys)
        $.each @hotkeys, (hotkey, command) ->
            key hotkey, (e, handler)->
                console.log(hotkey)
                e.preventDefault()
                e.stopPropagation()
                document.execCommand(command, false, null)
                return true
            return true
        key 'enter', (e, handler)->
            console.log('enter')
            $('#edit div').contents().unwrap().wrap('<p/>')
        isOpenQuote = false
        isOpenDoubleQuote = false
        key '\'', (e) ->
            document.execCommand('insertHtml', false, if isOpenQuote then '&rsquo;' else '&lsquo;')
            isOpenQuote = !isOpenQuote
            e.preventDefault()
            e.stopPropagation()
        key 'shift+\'', (e) ->
            document.execCommand('insertHtml', false, if isOpenDoubleQuote then '&rdquo;' else '&ldquo;')
            isOpenDoubleQuote = !isOpenDoubleQuote
            e.preventDefault()
            e.stopPropagation()
         
jQuery ->
    $.get('http://127.0.0.1:5000/text.html', (data) ->
            $('#edit').html(data))
    editor = new Editor($('#edit'))
    editor.bindHotKeys()

    saver = () ->
        $.ajax({
            url: 'http://127.0.0.1:5000/text.html',
            method: 'POST',
            data: $('#edit').html(),
            success: (data) ->
                console.log(data)
            complete: () ->
                setTimeout(saver, 5000)
           })
    saver()

