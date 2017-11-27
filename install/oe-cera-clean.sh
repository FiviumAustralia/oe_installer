#!/bin/bash


# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "
USE openeyes

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM user WHERE id != 1;
DELETE FROM patient;
DELETE FROM ophtrintravitinjection_injectionuser;
DELETE FROM ophtrlaser_laser_operator;

DELETE FROM archive_family_history;
DELETE FROM archive_medication_adherence;
DELETE FROM archive_patient_allergy_assignment;
DELETE FROM archive_patient_risk_assignment;
DELETE FROM archive_previous_operation;
DELETE FROM archive_socialhistory;
DELETE FROM audit;
DELETE FROM automatic_examination_event_log;
DELETE FROM commissioning_body_patient_assignment;
DELETE FROM commissioning_body_practice_assignment;
DELETE FROM commissioning_body_service;
DELETE FROM commissioning_body;
DELETE FROM document_instance;
DELETE FROM document_set;
DELETE FROM episode_summary;
DELETE FROM episode;
DELETE FROM et_ophciexamination_adnexalcomorbidity;
DELETE FROM et_ophciexamination_allergies;
DELETE FROM et_ophciexamination_anteriorsegment_cct;
DELETE FROM et_ophciexamination_anteriorsegment;
DELETE FROM et_ophciexamination_bleb_assessment;
DELETE FROM et_ophciexamination_cataractsurgicalmanagement;
DELETE FROM et_ophciexamination_clinicoutcome;
DELETE FROM et_ophciexamination_colourvision;
DELETE FROM et_ophciexamination_comorbidities;
DELETE FROM et_ophciexamination_conclusion;
DELETE FROM et_ophciexamination_currentmanagementplan;
DELETE FROM et_ophciexamination_diagnoses;
DELETE FROM et_ophciexamination_dilation;
DELETE FROM et_ophciexamination_drgrading;
DELETE FROM et_ophciexamination_examinationrisk;
DELETE FROM et_ophciexamination_familyhistory;
DELETE FROM et_ophciexamination_fundus;
DELETE FROM et_ophciexamination_further_findings;
DELETE FROM et_ophciexamination_glaucomarisk;
DELETE FROM et_ophciexamination_gonioscopy;
DELETE FROM et_ophciexamination_history_medications;
DELETE FROM et_ophciexamination_history_risks;
DELETE FROM et_ophciexamination_history;
DELETE FROM et_ophciexamination_injectionmanagement;
DELETE FROM et_ophciexamination_injectionmanagementcomplex;
DELETE FROM et_ophciexamination_intraocularpressure;
DELETE FROM et_ophciexamination_investigation;
DELETE FROM et_ophciexamination_lasermanagement;
DELETE FROM et_ophciexamination_management;
DELETE FROM et_ophciexamination_medical_lids;
DELETE FROM et_ophciexamination_nearvisualacuity;
DELETE FROM et_ophciexamination_oct;
DELETE FROM et_ophciexamination_opticdisc;
DELETE FROM et_ophciexamination_overallmanagementplan;
DELETE FROM et_ophciexamination_pastsurgery;
DELETE FROM et_ophciexamination_posteriorpole;
DELETE FROM et_ophciexamination_postop_complications;
DELETE FROM et_ophciexamination_pupillaryabnormalities;
DELETE FROM et_ophciexamination_refraction;
DELETE FROM et_ophciexamination_risks;
DELETE FROM et_ophciexamination_surgical_lids;
DELETE FROM et_ophciexamination_systemic_diagnoses;
DELETE FROM et_ophciexamination_visualacuity;
DELETE FROM et_ophciexamination_visualfunction;
DELETE FROM et_ophciphasing_intraocularpressure;
DELETE FROM et_ophcocorrespondence_letter;
DELETE FROM et_ophcocvi_clericinfo;
DELETE FROM et_ophcocvi_clinicinfo;
DELETE FROM et_ophcocvi_consentsig;
DELETE FROM et_ophcocvi_eventinfo;
DELETE FROM et_ophcomessaging_message;
DELETE FROM et_ophcotherapya_exceptional;
DELETE FROM et_ophcotherapya_mrservicein;
DELETE FROM et_ophcotherapya_patientsuit;
DELETE FROM et_ophcotherapya_relativecon;
DELETE FROM et_ophcotherapya_therapydiag;
DELETE FROM et_ophdrprescription_details;
DELETE FROM et_ophinbiometry_biometrydat;
DELETE FROM et_ophinbiometry_calculation;
DELETE FROM et_ophinbiometry_iol_ref_values;
DELETE FROM et_ophinbiometry_measurement;
DELETE FROM et_ophinbiometry_selection;
DELETE FROM et_ophinlabresults_details;
DELETE FROM et_ophinvisualfields_comments;
DELETE FROM et_ophinvisualfields_condition;
DELETE FROM et_ophinvisualfields_image;
DELETE FROM et_ophinvisualfields_result;
DELETE FROM et_ophleepatientletter_epatientletter;
DELETE FROM et_ophleinjection_injection;
DELETE FROM et_ophouanaestheticsataudit_anaesthetis;
DELETE FROM et_ophouanaestheticsataudit_notes;
DELETE FROM et_ophouanaestheticsataudit_satisfactio;
DELETE FROM et_ophouanaestheticsataudit_vitalsigns;
DELETE FROM et_ophtrconsent_benfitrisk;
DELETE FROM et_ophtrconsent_leaflets;
DELETE FROM et_ophtrconsent_other;
DELETE FROM et_ophtrconsent_permissions;
DELETE FROM et_ophtrconsent_procedure;
DELETE FROM et_ophtrconsent_type;
DELETE FROM et_ophtrintravitinjection_anaesthetic;
DELETE FROM et_ophtrintravitinjection_complications;
DELETE FROM et_ophtrintravitinjection_postinject;
DELETE FROM et_ophtrintravitinjection_site;
DELETE FROM et_ophtrintravitinjection_treatment;
DELETE FROM et_ophtrlaser_anteriorseg;
DELETE FROM et_ophtrlaser_comments;
DELETE FROM et_ophtrlaser_fundus;
DELETE FROM et_ophtrlaser_posteriorpo;
DELETE FROM et_ophtrlaser_site;
DELETE FROM et_ophtrlaser_treatment;
DELETE FROM et_ophtroperationbooking_diagnosis;
DELETE FROM et_ophtroperationbooking_operation;
DELETE FROM et_ophtroperationbooking_scheduleope;
DELETE FROM et_ophtroperationnote_anaesthetic;
DELETE FROM et_ophtroperationnote_buckle;
DELETE FROM et_ophtroperationnote_cataract;
DELETE FROM et_ophtroperationnote_comments;
DELETE FROM et_ophtroperationnote_genericprocedure;
DELETE FROM et_ophtroperationnote_glaucomatube;
DELETE FROM et_ophtroperationnote_membrane_peel;
DELETE FROM et_ophtroperationnote_mmc;
DELETE FROM et_ophtroperationnote_personnel;
DELETE FROM et_ophtroperationnote_postop_drugs;
DELETE FROM et_ophtroperationnote_preparation;
DELETE FROM et_ophtroperationnote_procedurelist;
DELETE FROM et_ophtroperationnote_site_theatre;
DELETE FROM et_ophtroperationnote_surgeon;
DELETE FROM et_ophtroperationnote_tamponade;
DELETE FROM et_ophtroperationnote_trabectome;
DELETE FROM et_ophtroperationnote_trabeculectomy;
DELETE FROM et_ophtroperationnote_vitrectomy;
DELETE FROM event_issue;
DELETE FROM event;
DELETE FROM measurement_reference;
DELETE FROM media_data;
DELETE FROM mview_datapoint_node;
DELETE FROM ophciexamination_element_set_item;
DELETE FROM ophciexamination_element_set WHERE workflow_id != 1;
DELETE FROM ophciexamination_event_elementset_assignment;
DELETE FROM ophciexamination_workflow WHERE id != 1;
DELETE FROM ophciexamination_workflow_rule WHERE workflow_id != 1;
DELETE FROM ophcotherapya_decisiontree;
DELETE FROM ophcotherapya_decisiontreenode;
DELETE FROM ophcotherapya_decisiontreenodechoice;
DELETE FROM ophcotherapya_decisiontreenoderule;
DELETE FROM ophcotherapya_email;
DELETE FROM ophcotherapya_exceptional_pastintervention;
DELETE FROM ophcotherapya_patientsuit_decisiontreenoderesponse;
DELETE FROM ophcotherapya_treatment;
DELETE FROM ophinbiometry_imported_events;
DELETE FROM ophinbiometry_imported_events;
DELETE FROM ophtrconsent_leaflet_firm;
DELETE FROM ophtrconsent_leaflet_subspecialty;
DELETE FROM ophtrconsent_leaflet;
DELETE FROM ophtrintravitinjection_injectionuser;
DELETE FROM ophtrlaser_laser_operator;
DELETE FROM ophtrlaser_site_laser;
DELETE FROM ophtroperationbooking_admission_letter_warning_rule;
DELETE FROM ophtroperationbooking_anaesthetic_anaesthetic_type;
DELETE FROM ophtroperationbooking_letter_contact_rule;
DELETE FROM ophtroperationbooking_operation_booking;
DELETE FROM ophtroperationbooking_operation_date_letter_sent;
DELETE FROM ophtroperationbooking_operation_erod_rule_item;
DELETE FROM ophtroperationbooking_operation_erod_rule;
DELETE FROM ophtroperationbooking_operation_erod;
DELETE FROM ophtroperationbooking_operation_name_rule;
DELETE FROM ophtroperationbooking_operation_procedures_procedures;
DELETE FROM ophtroperationbooking_operation_sequence;
DELETE FROM ophtroperationbooking_operation_session;
DELETE FROM ophtroperationbooking_operation_theatre WHERE name != 'Default Theatre';
DELETE FROM ophtroperationbooking_operation_ward WHERE name != 'Default ward';
DELETE FROM ophtroperationbooking_waiting_list_contact_rule;
DELETE FROM ophtroperationbooking_whiteboard;
DELETE FROM ophtroperationnote_site_subspecialty_postop_instructions;
DELETE FROM pas_patient_merged;
DELETE FROM patient_contact_assignment;
DELETE FROM patient_measurement;
DELETE FROM patient_merge_request;
DELETE FROM patient_oph_info;
DELETE FROM patient_referral;
DELETE FROM patient_user_referral;
DELETE FROM patient;
DELETE FROM patientticketing_clinic_location;
DELETE FROM patientticketing_ticket;
DELETE FROM pcr_risk_values;
DELETE FROM practice;
DELETE FROM referral;
DELETE FROM secondary_diagnosis;
DELETE FROM site_subspecialty_operative_device;
DELETE FROM trial_patient;
DELETE FROM unique_codes_mapping;
DELETE FROM worklist_patient;
DELETE FROM gp;
DELETE FROM institution WHERE remote_id != 'CERA';

DELETE FROM firm
WHERE name NOT LIKE '%firm'
  AND name != 'Admin User';
DELETE FROM user WHERE id != 1;

UPDATE user
SET last_firm_id = 1
WHERE id = 1;

DELETE FROM contact
WHERE id != 1
  AND id NOT IN (
    SELECT contact_id
    FROM institution
    WHERE remote_id = 'CERA'
  )
  AND id NOT IN (
    SELECT contact_id
    FROM site 
    WHERE remote_id = 'CERA'
  );


SET FOREIGN_KEY_CHECKS = 1;

UPDATE firm SET active = FALSE WHERE id !=1 AND consultant_id IS NOT NULL;
UPDATE site SET active = FALSE WHERE remote_id != 'CERA';


#Clean up broken foreign keys
SET FOREIGN_KEY_CHECKS = 0; #Don't mind this, it looks odd but it's necessary
DELETE FROM openeyes.address
WHERE contact_id NOT IN (
    SELECT id
    FROM openeyes.contact
);

DELETE FROM openeyes.authassignment
WHERE userid NOT IN (
    SELECT id
    FROM openeyes.user
);

DELETE FROM openeyes.contact_location
WHERE contact_id NOT IN (
    SELECT id
    FROM openeyes.contact
);

DELETE FROM openeyes.contact_location
WHERE institution_id NOT IN (
    SELECT id
    FROM openeyes.institution
);

DELETE FROM openeyes.firm
WHERE consultant_id NOT IN (
    SELECT id
    FROM openeyes.user
);

DELETE FROM openeyes.ophciexamination_colourvision_reading
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_colourvision
);

DELETE FROM openeyes.ophciexamination_comorbidities_assignment
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_comorbidities
);

DELETE FROM openeyes.ophciexamination_diagnosis
WHERE element_diagnoses_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_diagnoses
);

DELETE FROM openeyes.ophciexamination_dilation_treatment
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_dilation
);

DELETE FROM openeyes.ophciexamination_history_medications_entry
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_history_medications
);

DELETE FROM openeyes.ophciexamination_injectmanagecomplex_answer
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_injectionmanagementcomplex
);

DELETE FROM openeyes.ophciexamination_injectmanagecomplex_risk_assignment
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_injectionmanagementcomplex
);

DELETE FROM openeyes.ophciexamination_intraocularpressure_value
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_intraocularpressure
);

DELETE FROM openeyes.ophciexamination_nearvisualacuity_reading
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_nearvisualacuity
);

DELETE FROM openeyes.ophciexamination_oct_fluidtype_assignment
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_oct
);

DELETE FROM openeyes.ophciexamination_systemic_diagnoses_diagnosis
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_systemic_diagnoses
);

DELETE FROM openeyes.ophciexamination_visualacuity_reading
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophciexamination_visualacuity
);

DELETE FROM openeyes.ophcocorrespondence_firm_site_secretary
WHERE firm_id NOT IN (
    SELECT id
    FROM openeyes.firm
);

DELETE FROM openeyes.ophcocorrespondence_letter_enclosure
WHERE element_letter_id NOT IN (
    SELECT id
    FROM openeyes.et_ophcocorrespondence_letter
);

DELETE FROM openeyes.ophdrprescription_item
WHERE prescription_id NOT IN (
    SELECT id
    FROM openeyes.et_ophdrprescription_details
);

DELETE FROM openeyes.ophinbiometry_calculation_formula
WHERE created_user_id NOT IN (
    SELECT id
    FROM openeyes.user
);

DELETE FROM openeyes.ophinbiometry_calculation_formula
WHERE last_modified_user_id NOT IN (
    SELECT id
    FROM openeyes.user
);

DELETE FROM openeyes.ophinbiometry_lenstype_lens
WHERE created_user_id NOT IN (
    SELECT id
    FROM openeyes.user
);

DELETE FROM openeyes.ophinbiometry_lenstype_lens
WHERE last_modified_user_id NOT IN (
    SELECT id
    FROM openeyes.user
);

DELETE FROM openeyes.ophtrconsent_procedure_add_procs_add_procs
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtrconsent_procedure
);

DELETE FROM openeyes.ophtrconsent_procedure_anaesthetic_type
WHERE et_ophtrconsent_procedure_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtrconsent_procedure
);

DELETE FROM openeyes.ophtrconsent_procedure_procedures_procedures
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtrconsent_procedure
);

DELETE FROM openeyes.ophtrintravitinjection_complicat_assignment
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtrintravitinjection_complications
);

DELETE FROM openeyes.ophtrintravitinjection_ioplowering_assign
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtrintravitinjection_treatment
);

DELETE FROM openeyes.ophtrlaser_laserprocedure_assignment
WHERE treatment_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtrlaser_treatment
);

DELETE FROM openeyes.ophtroperationbooking_scheduleope_patientunavail
WHERE element_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationbooking_scheduleope
);

DELETE FROM openeyes.ophtroperationnote_anaesthetic_anaesthetic_agent
WHERE et_ophtroperationnote_anaesthetic_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_anaesthetic
);

DELETE FROM openeyes.ophtroperationnote_anaesthetic_anaesthetic_complication
WHERE et_ophtroperationnote_anaesthetic_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_anaesthetic
);

DELETE FROM openeyes.ophtroperationnote_anaesthetic_anaesthetic_delivery
WHERE et_ophtroperationnote_anaesthetic_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_anaesthetic
);

DELETE FROM openeyes.ophtroperationnote_anaesthetic_anaesthetic_type
WHERE et_ophtroperationnote_anaesthetic_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_anaesthetic
);

DELETE FROM openeyes.ophtroperationnote_cataract_complication
WHERE cataract_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_cataract
);

DELETE FROM openeyes.ophtroperationnote_cataract_operative_device
WHERE cataract_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_cataract
);

DELETE FROM openeyes.ophtroperationnote_postop_drugs_drug
WHERE ophtroperationnote_postop_drugs_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_postop_drugs
);

DELETE FROM openeyes.ophtroperationnote_procedurelist_procedure_assignment
WHERE procedurelist_id NOT IN (
    SELECT id
    FROM openeyes.et_ophtroperationnote_procedurelist
);

DELETE FROM openeyes.patientticketing_queuesetuser
WHERE user_id NOT IN (
    SELECT id
    FROM openeyes.user
);

DELETE FROM openeyes.patientticketing_ticketqueue_assignment
WHERE assignment_firm_id NOT IN (
    SELECT id
    FROM openeyes.firm
);

DELETE FROM openeyes.patientticketing_ticketqueue_assignment
WHERE ticket_id NOT IN (
    SELECT id
    FROM openeyes.patientticketing_ticket
);

DELETE FROM openeyes.site
WHERE contact_id NOT IN (
    SELECT id
    FROM openeyes.contact
);

DELETE FROM openeyes.site
WHERE institution_id NOT IN (
    SELECT id
    FROM openeyes.institution
);

DELETE FROM openeyes.site
WHERE replyto_contact_id NOT IN (
    SELECT id
    FROM openeyes.contact
);

UPDATE user
SET last_site_id = (SELECT id FROM site LIMIT 1);

DELETE FROM openeyes.ophcocorrespondence_firm_site_secretary
WHERE site_id NOT IN (
    SELECT id
    FROM openeyes.site
);

DELETE FROM openeyes.ophcocorrespondence_letter_macro
WHERE site_id NOT IN (
    SELECT id
    FROM openeyes.site
);

DELETE FROM openeyes.ophcocorrespondence_letter_string
WHERE site_id NOT IN (
    SELECT id
    FROM openeyes.site
);

DELETE FROM openeyes.ophcotherapya_email_recipient
WHERE site_id NOT IN (
    SELECT id
    FROM openeyes.site
);

DELETE FROM openeyes.ophdrprescription_item_taper
WHERE item_id NOT IN (
    SELECT id
    FROM openeyes.ophdrprescription_item
);

DELETE FROM openeyes.ophtroperationnote_postop_site_subspecialty_drug
WHERE site_id NOT IN (
    SELECT id
    FROM openeyes.site
);

DELETE FROM openeyes.site_subspecialty_anaesthetic_agent
WHERE site_id NOT IN (
    SELECT id
    FROM openeyes.site
);

DELETE FROM openeyes.site_subspecialty_drug
WHERE site_id NOT IN (
    SELECT id
    FROM openeyes.site
);
SET FOREIGN_KEY_CHECKS = 1;

;;
" > /tmp/openeyes-mysql-cera-setup.sql


mysql -u root "-ppassword" --delimiter=";;" < /tmp/openeyes-mysql-cera-setup.sql
rm /tmp/openeyes-mysql-cera-setup.sql