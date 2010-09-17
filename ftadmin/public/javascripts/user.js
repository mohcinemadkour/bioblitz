
		$(document).ready(function() {
			$('#email').click(function(){
				if ($(this).attr('value')=="email") $(this).attr('value','');
			});
			$('#password').click(function(){
				if ($(this).attr('value')=="password") $(this).attr('value','');
			});
			$('#email').focusout(function(){
				if ($(this).attr('value')=="") $(this).attr('value','email');
			});
			$('#password').focusout(function(){
				if ($(this).attr('value')=="") $(this).attr('value','password');
			});
			
		});


		function checkLoginOption(element) {
			if (element=='login') {
				if (!$('div.login').hasClass('selected')) {
					$('div.register').css('height','auto');
					$('div.login').css('height','61px');
					$('div.register').removeClass('selected');
					$('div.login').addClass('selected');
				}
			} else {
				if (!$('div.register').hasClass('selected')) {
					$('div.register').css('height','258px');
					$('div.login').css('height','auto');
					$('div.login').removeClass('selected');
					$('div.register').addClass('selected');
				}
			}
		}
		
		
		function checkForm(ev) {
			ev.stopPropagation();
			ev.preventDefault();
			if ($('#user_name').attr('value').length==0 || $('#reg_mail').attr('value').length<5 || $('#user_password_confirmation').attr('value').length<5 || $('#user_password').attr('value').length<5) {
				$('p#error_msg').text('Hey! There are empty fields');
				return false;
			}
		
			if (!echeck($('#reg_mail').attr('value'))) {
				$('p#error_msg').text('Email is incorrect');
				return false;
			}
			
			if ($('#user_password_confirmation').attr('value')!=$('#user_password').attr('value')) {
				$('p#error_msg').text('Passwords are different');
				return false;
			}
			
			$('div.register form').submit();
		}
		
		
		
		//CHECK EMAIL JAVASCRIPT
		function echeck(str) {

		        var at="@"
		        var dot="."
		        var lat=str.indexOf(at)
		        var lstr=str.length
		        var ldot=str.indexOf(dot)
		        if (str.indexOf(at)==-1){
		           return false
		        }

		        if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		           return false
		        }

		        if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		            return false
		        }

		         if (str.indexOf(at,(lat+1))!=-1){
		            return false
		         }

		         if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		            return false
		         }

		         if (str.indexOf(dot,(lat+2))==-1){
		            return false
		         }

		         if (str.indexOf(" ")!=-1){
		            return false
		         }

		         return true
		}