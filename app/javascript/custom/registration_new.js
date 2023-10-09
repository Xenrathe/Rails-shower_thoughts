// Function to check Whether both passwords
// is same or not.

function password_check() {
  const password1 = document.getElementById("user_password");
  const password2 = document.getElementById("user_password_confirmation");
  const error_msg = document.getElementById('password-mismatch-msg');

  //Default mode is error
  error_msg.style.color = 'red';
  password1.setCustomValidity("Invalid field.");
  password2.setCustomValidity("Invalid field.");

  if (password1.value != '' || password2.value != ''){
    if (password1.value != password2.value){
      error_msg.innerHTML = '* Passwords do not match';
    }
    else{
      if (password1.value.length < 6) {
        error_msg.innerHTML = '* Minimum length is 6 characters';
      }
      else if (password1.value.length > 128) {
        error_msg.innerHTML = '* Maximum length is 6 characters';
      }
      else {
        error_msg.style.color = 'green';
        error_msg.innerHTML = 'Passwords match'
        password1.setCustomValidity("");
        password2.setCustomValidity("");
      }
    }
  }
  else{
    error_msg.innerHTML = '* Password required';
  }
}

const passwordA = document.getElementById("user_password");
const passwordB = document.getElementById("user_password_confirmation");
passwordA.addEventListener('keyup', password_check);
passwordB.addEventListener('keyup', password_check);