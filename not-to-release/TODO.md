# Open questions about Malayalam UD annotation

* Finalize the inventory of verbal features and values. Make sure it is well documented.
* How are we going to annotate the perfect progressive aspect? `Aspect=PerfProg`? In the current data, the form _cīkikkoṇṭirikkaṇaṁ_ may be an example of this.
* How are we going to annotate interrogative forms of verbs? `Mood=Int` is currently used in Irish, Scottish Gaelic, Uyghur, and Yupik.
  Or `Int=Yes`, currently used in four Tupian languages and in Yakut. The problem is that interrogativity may cut across other moods, e.g., necessitative.
  That speaks in favor of using a separate feature rather than a `Mood` value. Otherwise we would have to resort to combined values again (`Mood=NecInt`).
  Combined values already exist in Turkish, although not exactly with `Int`.
* Can a dative nominal be a core argument in Malayalam? One instance got `iobj` in cairo07. But maybe it will get `obl` elsewhere?
  And what about the "dative subjects"? Related debate about `iobj` in the UD core group: Lori:
  "relational grammar – there can be unemployed objects (bumped out of place), which look like objects but do not behave like objects."
