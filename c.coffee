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
        getPreviousCharacter = (selection) ->
            if selection == undefined
                selection = window.getSelection()
            range = document.createRange()
            range.setStart(selection.baseNode, selection.baseOffset - 1)
            range.setEnd(selection.baseNode, selection.baseOffset)
            console.log(range)
            return range.toString()
        key '\'', (e) ->
            document.execCommand('insertHtml', false, if isOpenQuote then '&rsquo;' else '&lsquo;')
            isOpenQuote = !isOpenQuote
            e.preventDefault()
            e.stopPropagation()
        key 'shift+\'', (e) ->
            console.log(e)
            document.execCommand('insertHtml', false, if isOpenDoubleQuote then '&rdquo;' else '&ldquo;')
            isOpenDoubleQuote = !isOpenDoubleQuote
            e.preventDefault()
            e.stopPropagation()
        key 'space', (e) ->
            console.log('minus')
            console.log(e)
            selection = window.getSelection()
            if selection.baseOffset == 1
                char = getPreviousCharacter(selection)
                console.log(char)
                if char != '1' and char != '-'
                    return
                if char == '1'
                    document.execCommand('insertorderedlist', false, null)
                else if char == '-'
                    document.execCommand('insertunorderedlist', false, null)
                document.execCommand('delete', false, null)
                e.preventDefault()
                e.stopPropagation()
        key '-', (e) ->
            if getPreviousCharacter() == '-'
                document.execCommand('delete', false, null)
                document.execCommand('insertHtml', false, '&mdash;')
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

