class Editor
    getLineToCursor: =>
        selection = window.getSelection()
        range = document.createRange()
        range.setStart(selection.baseNode, 0)
        range.setEnd(selection.baseNode, selection.baseOffset)
        return range.toString()
    handleQuote: (typeQuote) =>
        if typeQuote == 'single'
            openQuote = '&lsquo;'
            closeQuote = '&rsquo;'
        else
            openQuote = '&ldquo;'
            closeQuote = '&rdquo;'
        text = @getLineToCursor()
        lastCharCode = text[-1..-1].charCodeAt(0)
        if text.length == 0
            quote = openQuote
        else if lastCharCode in [32, 160] and text.lastIndexOf openQuote <= text.lastIndexOf closeQuote
            quote = openQuote
        else
            quote = closeQuote
        document.execCommand('insertHtml', false, quote)
    handleBold: =>
        document.execCommand('bold', false, null)
    handleUnorderedList: =>
        document.execCommand('insertunorderedlist', false, null)
    handleOrderedList: =>
        document.execCommand('insertorderedlist', false, null)
    handleSingleQuote: =>
        @handleQuote('single')
    handleDoubleQuote: =>
        @handleQuote('double')
    getPreviousCharacter: (selection) =>
        if selection == undefined
            selection = window.getSelection()
        range = document.createRange()
        range.setStart(selection.baseNode, selection.baseOffset - 1)
        range.setEnd(selection.baseNode, selection.baseOffset)
        console.log(range)
        return range.toString()
    handleSpace: () =>
        selection = window.getSelection()
        if selection.baseOffset == 1
            char = @getPreviousCharacter(selection)
            console.log(char)
            if char != '1' and char != '-'
                return
            if char == '1'
                document.execCommand('insertorderedlist', false, null)
            else if char == '-'
                document.execCommand('insertunorderedlist', false, null)
            document.execCommand('delete', false, null)
        else
            return False
    handleEnter: () =>
        $('#edit div').contents().unwrap().wrap('<p/>')
        return False
    handleHyphen: () =>
        if @getPreviousCharacter() == '-'
            document.execCommand('delete', false, null)
            document.execCommand('insertHtml', false, '&mdash;')
        else
            return False
    constructor: (element) ->
        @element = element
    bindHotKeys: ->
        hotkeys = {
            'ctrl+b meta+b': @handleBold,
            'ctrl+u': @handleUndorderedLIst,
            'ctrl+shift+m meta+shift+m': @handleOrderedList,
            '\'': @handleSingleQuote,
            'shift+\'': @handleDoubleQuote,
            'space': @handleSpace,
            'enter': @handleEnter,
            '-': @handleHyphen
        }
        element = @element
        $.each hotkeys, (hotkey, handler) ->
            key hotkey, (e, _) ->
                console.log(hotkey)
                result = handler()
                console.log(result)
                if result
                    e.preventDefault()
                    e.stopPropagation()
                return true
            return true

jQuery ->
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
    $.get('http://127.0.0.1:5000/text.html', (data) ->
            $('#edit').html(data)
            saver()
    )
    editor = new Editor($('#edit'))
    editor.bindHotKeys()

