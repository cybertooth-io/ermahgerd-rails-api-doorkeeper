# frozen_string_literal: true

# The JSONAPI Authorizing processor for namespaced policies.
# rubocop:disable Metrics/ClassLength, Rails/DynamicFindBy
class NamespacedAuthorizingProcessor < JSONAPI::Authorization::AuthorizingProcessor
  def authorize_find
    authorizer.find(source_class: policy_class(@resource_klass, @resource_klass._model_class))
  end

  def authorize_show
    record = @resource_klass.find_by_key(
      operation_resource_id,
      context: context
    )._model

    authorizer.show(source_record: policy_class(@resource_klass, record))
  end

  def authorize_show_relationship
    parent_resource = @resource_klass.find_by_key(
      params[:parent_key],
      context: context
    )

    relationship = @resource_klass._relationship(params[:relationship_type].to_sym)

    related_resource =
      case relationship
      when JSONAPI::Relationship::ToOne
        parent_resource.public_send(params[:relationship_type].to_sym)
      when JSONAPI::Relationship::ToMany
        # Do nothing - already covered by policy scopes
        nil
      else
        raise "Unexpected relationship type: #{relationship.inspect}"
      end

    parent_record = parent_resource._model
    related_record = related_resource._model unless related_resource.nil?

    authorizer.show_relationship(
      source_record: policy_class(@resource_klass, parent_record),
      related_record: policy_class(related_resource, related_record)
    )
  end

  def authorize_show_related_resource
    source_klass = params[:source_klass]
    source_id = params[:source_id]
    relationship_type = params[:relationship_type].to_sym

    source_resource = source_klass.find_by_key(source_id, context: context)

    related_resource = source_resource.public_send(relationship_type)

    source_record = source_resource._model
    related_record = related_resource._model unless related_resource.nil?

    authorizer.show_related_resource(
      source_record: policy_class(source_resource, source_record),
      related_record: policy_class(related_resource, related_record)
    )
  end

  def authorize_show_related_resources
    record = params[:source_klass].find_by_key(
      params[:source_id],
      context: context
    )._model

    authorizer.show_related_resources(source_record: policy_class(params[:source_klass], record))
  end

  def authorize_replace_fields
    record = @resource_klass.find_by_key(
      params[:resource_id],
      context: context
    )._model

    authorizer.replace_fields(
      source_record: policy_class(@resource_klass, record),
      related_records_with_context: related_models_with_context
    )
  end

  def authorize_create_resource
    model_klass = @resource_klass._model_class

    authorizer.create_resource(
      source_class: policy_class(@resource_klass, model_klass),
      related_records_with_context: related_models_with_context
    )
  end

  def authorize_remove_resource
    record = @resource_klass.find_by_key(
      operation_resource_id,
      context: context
    )._model

    authorizer.remove_resource(source_record: policy_class(@resource_klass, record))
  end

  def authorize_replace_to_one_relationship
    return authorize_remove_to_one_relationship if params[:key_value].nil?

    source_resource = @resource_klass.find_by_key(
      params[:resource_id],
      context: context
    )
    source_record = source_resource._model

    relationship_type = params[:relationship_type].to_sym
    new_related_resource = @resource_klass
                           ._relationship(relationship_type)
                           .resource_klass
                           .find_by_key(
                             params[:key_value],
                             context: context
                           )
    new_related_record = new_related_resource._model unless new_related_resource.nil?

    authorizer.replace_to_one_relationship(
      source_record: policy_class(source_resource, source_record),
      new_related_record: policy_class(new_related_resource, new_related_record),
      relationship_type: relationship_type
    )
  end

  def authorize_create_to_many_relationships
    source_record = @resource_klass.find_by_key(
      params[:resource_id],
      context: context
    )._model

    relationship_type = params[:relationship_type].to_sym
    related_models = model_class_for_relationship(relationship_type).find(params[:data])

    authorizer.create_to_many_relationship(
      source_record: policy_class(@resource_klass, source_record),
      new_related_records: related_models,
      relationship_type: relationship_type
    )
  end

  def authorize_replace_to_many_relationships
    source_resource = @resource_klass.find_by_key(
      params[:resource_id],
      context: context
    )
    source_record = source_resource._model

    relationship_type = params[:relationship_type].to_sym
    new_related_records = model_class_for_relationship(relationship_type).find(params[:data])

    authorizer.replace_to_many_relationship(
      source_record: policy_class(source_resource, source_record),
      new_related_records: new_related_records,
      relationship_type: relationship_type
    )
  end

  def authorize_remove_to_many_relationships
    source_resource = @resource_klass.find_by_key(
      params[:resource_id],
      context: context
    )
    source_record = source_resource._model

    relationship_type = params[:relationship_type].to_sym

    related_resources = @resource_klass
                        ._relationship(relationship_type)
                        .resource_klass
                        .find_by_keys(
                          params[:associated_keys],
                          context: context
                        )

    related_records = related_resources.map(&:_model)

    authorizer.remove_to_many_relationship(
      source_record: policy_class(source_resource, source_record),
      related_records: related_records,
      relationship_type: relationship_type
    )
  end

  def authorize_remove_to_one_relationship
    source_record = @resource_klass.find_by_key(
      params[:resource_id],
      context: context
    )._model

    relationship_type = params[:relationship_type].to_sym

    authorizer.remove_to_one_relationship(
      source_record: policy_class(@resource_klass, source_record), relationship_type: relationship_type
    )
  end

  def authorize_replace_polymorphic_to_one_relationship
    return authorize_remove_to_one_relationship if params[:key_value].nil?

    source_resource = @resource_klass.find_by_key(
      params[:resource_id],
      context: context
    )
    source_record = source_resource._model

    # Fetch the name of the new class based on the incoming polymorphic
    # "type" value. This will fail if there is no associated resource for the
    # incoming "type" value so this shouldn't leak constants
    related_record_class_name = source_resource
                                .send(:_model_class_name, params[:key_type])

    # Fetch the underlying Resource class for the new record to-be-associated
    related_resource_klass = @resource_klass.resource_for(related_record_class_name)

    new_related_resource = related_resource_klass
                           .find_by_key(
                             params[:key_value],
                             context: context
                           )
    new_related_record = new_related_resource._model unless new_related_resource.nil?

    relationship_type = params[:relationship_type].to_sym

    authorizer.replace_to_one_relationship(
      source_record: policy_class(source_resource, source_record),
      new_related_record: policy_class(new_related_resource, new_related_record),
      relationship_type: relationship_type
    )
  end

  private

  def policy_class(resource_klass, model_klass_or_instance)
    return nil if resource_klass.nil? || model_klass_or_instance.nil?

    resource_klass.parent.name.split('::').map(&:to_sym).push(model_klass_or_instance)
  end
end
# rubocop:enable Metrics/ClassLength, Rails/DynamicFindBy
