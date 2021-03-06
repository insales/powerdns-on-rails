class MacroStepsController < InheritedResources::Base

  belongs_to :macro
  respond_to :xml, :json, :js

  protected

  def parent
    Macro.user( current_user ).find( params[:macro_id] )
  end

  def collection
    parent.macro_steps
  end

  def resource
    collection.find( params[:id] )
  end

  def macro_step_params
    return {} unless params[:macro_step].present?

    params.require(:macro_step).permit(
      :action,
      :record_type,
      :name,
      :content,
      :ttl,
      :prio,
      :active,
      :note,
      :position,
    )
  end

  public

  def create
    # Check for any previous macro steps
    if parent.macro_steps.any?
      # Check for the parameter
      unless params[:macro_step][:position].blank?
        position = params[:macro_step].delete(:position)
      else
        position = parent.macro_steps.last.position + 1
      end
    else
      position = '1'
    end

    @macro_step = parent.macro_steps.create(macro_step_params)

    @macro_step.insert_at( position.to_i ) if position && !@macro_step.new_record?

    parent.save
    @macro = parent

    respond_to do |format|
      format.js
    end
  end

  def update
    position = params[:macro_step].delete(:position)

    @macro_step = parent.macro_steps.find( params[:id] )
    @macro_step.update(macro_step_params)

    @macro_step.insert_at( position.to_i ) if position

    @macro = parent

    respond_to do |wants|
      wants.js
    end
  end

  def destroy
    @macro_step = parent.macro_steps.find( params[:id] )
    @macro_step.destroy

    flash[:info] = t :message_macro_step_removed
    redirect_to macro_path( parent )
  end

end
