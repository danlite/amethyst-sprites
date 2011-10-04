SERIES_STATES = [
  SERIES_RESERVED = 'reserved',
  SERIES_WORKING = 'working',
  SERIES_AWAITING_EDIT = 'awaiting_edit',
  SERIES_EDITING = 'editing',
  SERIES_AWAITING_QC = 'awaiting_qc',
  SERIES_QC = 'qc',
  SERIES_AWAITING_APPROVAL = 'awaiting_approval',
  SERIES_DONE = 'done',
  SERIES_ARCHIVED = 'archived'
]

SPRITE_STEPS = [
  SPRITE_WORK = 'work',
  SPRITE_EDIT = 'edit',
  SPRITE_QC = 'qc',
  SPRITE_REVAMP = 'revamp'
]

def state_compare(s1, s2)
  SERIES_STATES.index(s1) <=> SERIES_STATES.index(s2)
end