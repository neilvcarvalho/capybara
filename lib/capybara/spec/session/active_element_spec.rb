# frozen_string_literal: true

Capybara::SpecHelper.spec '#active_element', requires: [:js] do
  it 'should return the active element' do
    @session.visit('/form')
    @session.send_keys(:tab)

    expect(@session.active_element).to match_selector(:css, '#form_title');

    @session.send_keys(:tab)

    expect(@session.active_element).not_to match_selector(:css, '#form_title');
  end

  it 'should support reloading' do
    @session.visit('/form')
    expect(@session.active_element).to match_selector(:css, 'body')
    @session.execute_script <<-JS
      window.setTimeout(() => {
        document.querySelector('#form_title').focus();
      }, 1000)
    JS
    expect(@session.active_element).to match_selector(:css, 'body', wait: false)
    expect(@session.active_element).to match_selector(:css, '#form_title', wait: 2)
  end
end
