// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Popup={
  popup_ticket: function(url) {
    if(Element.visible($('ticket'))){
      Element.show('spinner');
      new Ajax.Request(url + '?popup=0', {asynchronous:true, evalScripts:true, method:'get', onComplete:function(request){Element.hide('spinner')}});
    }
    else{
      Element.show('spinner');
      new Ajax.Request(url + '?popup=1', {asynchronous:true, evalScripts:true, method:'get', onComplete:function(request){Element.hide('spinner')}});
    }
  },
  choose_color: function(number){
    switch(number*1){
      case 1:
        for (i = 1; i <= 9; i++)
          i == 1 ? $('priority_' + i).style.background='#11a300' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 1; $('ticket[severity]').value = 1;
        break;
      case 2:
        for (i = 1; i <= 9; i++)
          i == 2 ? $('priority_' + i).style.background='#8aff00' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 1; $('ticket[severity]').value = 2;
        break;
      case 3:
        for (i = 1; i <= 9; i++)
          i == 3 ? $('priority_' + i).style.background='#efbbb2' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 1; $('ticket[severity]').value = 3;
        break;
      case 4:
        for (i = 1; i <= 9; i++)
          i == 4 ? $('priority_' + i).style.background='#8aff00' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 2;
        $('ticket[severity]').value = 1;
        break;
      case 5:
        for (i = 1; i <= 9; i++)
          i == 5 ? $('priority_' + i).style.background='#fff000' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 2;
        $('ticket[severity]').value = 2;
        break;
      case 6:
        for (i = 1; i <= 9; i++)
          i == 6 ? $('priority_' + i).style.background='#ff8c00' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 2; $('ticket[severity]').value = 3;
        break;
      case 7:
        for (i = 1; i <= 9; i++)
          i == 7 ? $('priority_' + i).style.background='#efbbb2' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 3; $('ticket[severity]').value = 1;
        break;
      case 8:
        for (i = 1; i <= 9; i++)
          i == 8 ? $('priority_' + i).style.background='#ff8c00' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 3; $('ticket[severity]').value = 2;
        break;
      case 9:
        for (i = 1; i <= 9; i++)
          i == 9 ? $('priority_' + i).style.background='#ff2400' : $('priority_' + i ).style.background='white';
        $('ticket[urgency]').value = 3; $('ticket[severity]').value = 3;
        break;
    }
  }
};