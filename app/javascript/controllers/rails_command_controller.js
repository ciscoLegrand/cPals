import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'output', 'preset', 'database', 'housekeeping', 'pipeline','javascript', 'css', 'goodies', 'tests']

  connect() {
    console.log('FlagCommandController connected!')
    this.updateOutput()
  }

  updateOutput() {
    const appName             = this.getAppName()
    const presetCommand       = this.getPresetCommand()
    const databaseCommand     = this.getDatabaseCommand()
    const housekeepingCommand = this.getHousekeepingCommand()
    const pipelineCommand     = this.getPipelineCommand()
    const javascriptCommand   = this.getJavascriptCommand()
    const cssCommand          = this.getCssCommand()
    const activeCommand       = this.getActiveCommand()
    const testCommand         = this.getTestCommand()
    this.outputTarget.innerHTML = `<span class="hljs-keyword">rails</span> <span class="hljs-title">new</span> <span class="hljs-string">${appName}</span> <span class="w-full hljs-subst">${presetCommand} ${databaseCommand} ${housekeepingCommand} ${pipelineCommand} ${javascriptCommand} ${cssCommand} ${activeCommand} ${testCommand}</span>`
  }

  getAppName() {
    return this.inputTarget.value
  }

  getPresetCommand() {
    const selectedPreset = this.presetTargets.find(radio => radio.checked)
    console.log(selectedPreset.value)
    if (selectedPreset.value === 'preset_none') { return '' }
    return `--${selectedPreset.value}`
  }

  getDatabaseCommand() {
    const selectedDatabase = this.databaseTargets.find(radio => radio.checked)
    return selectedDatabase ? `--database=${selectedDatabase.value}` : ''
  }

  getHousekeepingCommand() {
    console.log('Housekeeping targets:', this.housekeepingTargets)
    const defaultSkips = ['gitignore', 'keeps', 'bootsnap', 'bundle']
    const checkedFlags = this.housekeepingTargets.filter(checkbox => checkbox.checked).map(checkbox => checkbox.value)
  
    console.log('Checked flags:', checkedFlags)
    const skipCommands = defaultSkips
      .filter(flag => !checkedFlags.includes(flag))
      .map(flag => `--skip-${flag}`)
      .join(' ')
  
    console.log('Skip commands:', skipCommands)
    return skipCommands === '' ? '' : (skipCommands || '--skip-gitignore --skip-keeps --skip-bootsnap --skip-bundle')

  }

  getPipelineCommand() {
    const selectedPipeline = this.pipelineTargets.find(radio => radio.checked)
    if (selectedPipeline.value === 'pipeline_none') { return '--skip-asset-pipeline' }
    if (selectedPipeline.value === 'propshaft') { return '--asset-pipeline=propshaft' }
    return ''
  }

  getJavascriptCommand() {
    const selectedJS = this.javascriptTargets.find(radio => radio.checked)
    if(selectedJS.value === 'javascript_none') { return '--skip-javascript' }
    return selectedJS ? `--javascript=${selectedJS.value}` : ''
  }

  getCssCommand() {
    const selectedCss = this.cssTargets.find(radio => radio.checked)
    if (selectedCss.value === 'css_none') { return '' }
    return `--css=${selectedCss.value}`
  }

  getActiveCommand() {
    console.log('Goodies targets:', this.goodiesTargets)
    const defaultSkips = ['cable', 'job', 'mailbox', 'mailer', 'record', 'storage', 'text', 'hotwire', 'jbuilder']
    const checkedFlags = this.goodiesTargets.filter(checkbox => checkbox.checked).map(checkbox => checkbox.value)
    const skipCommands = defaultSkips
      .filter(flag => !checkedFlags.includes(flag))
      .map(flag => `--skip-${flag}`)
      .join(' ')
    return skipCommands === '' ? '' : skipCommands
  }

  getTestCommand() {
    const defaultSkips = ['test', 'system-test']
    const checkedFlags = this.testsTargets.filter(checkbox => checkbox.checked).map(checkbox => checkbox.value)
  
    const skipCommands = defaultSkips
      .filter(flag => !checkedFlags.includes(flag))
      .map(flag => `--skip-${flag}`)
      .join(' ')
  
    return skipCommands
  }
}
