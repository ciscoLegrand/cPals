# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'User Access to Restricted Area', type: :feature do
  scenario 'User visits restricted area and is redirected to login page' do
    # Paso 1: Visitar la página de inicio
    visit root_path
    expect(page).to have_content('Please sign in to continue')

    # paso 2: Hcacer click en el enlace del nav con el texto chatia
    click_link 'ChatIA'

    # Paso 3: Intentar visitar una página restringida
    visit chatia_path
    expect(current_path).to eq(new_user_session_path)

    # Paso 4: Se muestra el formulario de inicio de sesión
    expect(page).to have_content('Log in')

    # Paso 5: Intentar iniciar sesión con credenciales incorrectas
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'wrongpassword'
    click_button 'Log in'

    # Esperar mensaje de error
    expect(page).to have_content('Invalid Email or password')

    # Paso 6: Ir al formulario de registro
    click_link 'Registro'
    expect(current_path).to eq(new_user_registration_path)

    # Paso 7: Llenar y enviar el formulario de registro
    valid_data = {
      email: Faker::Internet.email,
      password: 'password'
    }

    fill_in 'Email', with: valid_data[:email]
    fill_in 'Password', with: valid_data[:password]
    fill_in 'Password confirmation', with: valid_data[:password]
    click_button 'Registro'

    # Paso 8: Confirmar la cuenta del usuario
    user = User.last
    expect(user.confirmed?).to be_falsey
    expect(user).to be_valid
    user.confirm
    expect(user.confirmed?).to be_truthy

    # Paso 9: Hacer clic en el enlace de inicio de sesión en el user card component desplegable
    click_button 'guest'

    # Paso 10: Hacer clic en el enlace de inicio de sesión en el menú desplegable
    click_link 'Login'

    # Paso 11: Iniciar sesión con el nuevo usuario
    fill_in 'Email', with: user.email
    fill_in 'Password', with: valid_data[:password]
    click_button 'Log in'

    # Paso 12: Verificar que se ha redirigido al usuario a la página restringida
    expect(current_path).to eq(chatia_path)
    expect(page).to have_content('gpt-3.5-turbo')
  end
end
# rubocop:enable Metrics/BlockLength
