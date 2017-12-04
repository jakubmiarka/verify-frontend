class CleverQuestions::SelectPhoneController < ApplicationController
  def index
    @form = CleverQuestions::SelectPhoneForm.new({})
  end

  def select_phone
    @form = CleverQuestions::SelectPhoneForm.new(params['select_phone_form'] || {})
    if @form.valid?
      report_to_analytics('Phone Next')
      current_answers = selected_answer_store.selected_answers['phone'] || {}
      selected_answer_store.store_selected_answers('phone', current_answers.symbolize_keys.merge(@form.selected_answers))
      idps_available = IDP_ELIGIBILITY_CHECKER.any?(selected_evidence, current_identity_providers_for_loa)
      redirect_to idps_available ? choose_a_certified_company_path : no_mobile_phone_path
    else
      flash.now[:errors] = @form.errors.full_messages.join(', ')
      render :index
    end
  end

  def no_mobile_phone
    @other_ways_description = current_transaction.other_ways_description
    @other_ways_text = current_transaction.other_ways_text
  end
end
