require 'rails_helper'

RSpec.describe User, type: :model do
  # Validaciones de atributos
  it 'validates presence of email' do
    user = User.new(email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include(I18n.t('errors.messages.blank'))
  end

  it 'validates uniqueness of email' do
    existing_user = FactoryBot.create(:user)
    user = User.new(email: existing_user.email)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include(I18n.t('errors.messages.taken'))
  end

  it 'validates email format' do
    user = User.new(email: 'invalid_email')
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include(I18n.t('errors.messages.invalid'))
  end

  it 'validates presence and uniqueness of username' do
    user = FactoryBot.build(:user, username: nil)
    expect(user).to be_valid

    existing_user = FactoryBot.create(:user, username: 'testuser')
    user_with_same_username = FactoryBot.build(:user, username: 'testuser')
    expect(user_with_same_username).not_to be_valid
    expect(user_with_same_username.errors[:username]).to include(I18n.t('errors.messages.taken'))
  end

  it 'validates username length' do
    user = User.new(username: 'ab')
    expect(user).not_to be_valid
    expect(user.errors[:username]).to include(I18n.t('errors.messages.too_short', count: 3))

    long_username = 'a' * 51
    user = User.new(username: long_username)
    expect(user).not_to be_valid
    expect(user.errors[:username]).to include(I18n.t('errors.messages.too_long', count: 50))
  end

  # Enum role
  it 'has user and admin roles' do
    expect(User.roles.keys).to match_array(%w[user admin])
  end

  it 'has user and admin validate roles' do
    user = FactoryBot.build(:user, role: :user)
    expect(user).to be_valid

    admin = FactoryBot.build(:user, role: :admin)
    expect(admin).to be_valid
  end

  it 'change role from user to admin' do
    user = FactoryBot.create(:user)
    expect(user.role).to eq('user')
    expect(user.user?).to be_truthy
    expect(user).to be_user

    user.admin!
    expect(user.role).to eq('admin')
    expect(user.admin?).to be_truthy
    expect(user).to be_admin
  end

  # devise specs
  ## database authenticatable & registerable
  it 'authenticates with valid credentials' do
    user = FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123')
    authenticated_user = user.valid_password?('password123')
    expect(authenticated_user).to be_truthy
  end

  it 'does not authenticate with invalid credentials' do
    user = FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123')
    authenticated_user = user.valid_password?('wrongpassword')
    expect(authenticated_user).to be_falsey
  end

  # recoverable
  it 'sends password reset instructions' do
    user = FactoryBot.create(:user)
    expect { user.send_reset_password_instructions }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  # confirmable
  it 'is confirmable' do
    user = FactoryBot.create(:user)
    expect(user.confirmed?).to be_falsey
    user.confirm
    expect(user.confirmed?).to be_truthy
  end

  it 'sends confirmation instructions' do
    user = FactoryBot.create(:user)
    expect do
      user.send_confirmation_instructions
    end.to change {
      ActionMailer::Base.deliveries.count
    }.by(1)
  end

  # trackable
  it 'tracks sign in count' do
    user = FactoryBot.create(:user)
    expect(user.sign_in_count).to eq(0)
    user.update(sign_in_count: user.sign_in_count + 1)
    expect(user.sign_in_count).to eq(1)
  end
end
