extends VBoxContainer

var selected_banner: TowerBuyBanner = null


func _ready():
	setup_banner_tracking()


func _on_banner_pressed(banner: TowerBuyBanner):
	if selected_banner:
		selected_banner.is_selected = false
		selected_banner.hide_outline()
	
	if selected_banner == banner:
		selected_banner = null
		return
	
	selected_banner = banner
	selected_banner.is_selected = true
	selected_banner.show_outline()

func _on_banner_selected(banner: TowerBuyBanner):
	if selected_banner:
		selected_banner.is_selected = false
		selected_banner.hide_outline()
	
	selected_banner = banner
	selected_banner.is_selected = true
	selected_banner.show_outline()

func setup_banner_tracking():
	for buy_menu_row in get_children():
		for banner in buy_menu_row.get_children():
			banner.connect("banner_pressed", _on_banner_pressed.bind(banner))
			banner.connect("banner_selected", _on_banner_selected.bind(banner))
