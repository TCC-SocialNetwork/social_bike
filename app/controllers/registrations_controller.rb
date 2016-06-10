class RegistrationsController < Users::RegistrationsController
  layout 'main', only: [:new]
end
