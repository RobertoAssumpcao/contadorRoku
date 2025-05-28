sub init()
  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "onFocusChange")
  m.fundo = m.top.findNode("fundo")
  m.relogio = m.top.findNode("relogio")
  largura = m.top.boundingRect().width
  altura = m.top.boundingRect().height
  m.fundo.width = largura
  m.fundo.height = altura
  m.fundo.visible = true
  m.relogio.width = largura
  m.relogio.height = 0.15 * altura
  m.relogio.horizAlign = "center"
  m.relogio.vertAlign = "center"
  m.relogio.visible = true
  m.relogio.font.size = 120
  m.relogio.text = "00:00"
end sub

sub onVisibleChange()
  if m.top.visible
    m.fundo = m.top.findNode("fundo")
    m.relogio = m.top.findNode("relogio")
    m.top.setFocus(true)
    largura = m.top.boundingRect().width
    altura = m.top.boundingRect().height
    m.fundo.width = largura
    m.fundo.height = altura
    m.fundo.visible = true
    m.relogio.width = largura
    m.relogio.height = 0.15 * altura
    m.relogio.horizAlign = "center"
    m.relogio.vertAlign = "center"
    m.relogio.visible = true
    m.relogio.font.size = 120
    m.relogio.text = "00:00"
  end if
end sub

sub onFocusChange()
end sub

function onKeyEvent(key as string, press as boolean) as boolean
end function