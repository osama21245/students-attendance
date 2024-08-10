import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatefulWidget {
  final List<String> items;
  final Function(String)? onChanged;
  final String hintText;
  final double borderRadius;
  final double maxListHeight;
  final double borderWidth;
  final int defaultSelectedIndex;
  final bool enabled;

  const CustomDropDown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.hintText = '',
    this.borderRadius = 0,
    this.maxListHeight = 100,
    this.borderWidth = 1,
    this.defaultSelectedIndex = -1,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown>
    with WidgetsBindingObserver {
  bool _isOpen = false, _isAnyItemSelected = false, _isReverse = false;
  late OverlayEntry _overlayEntry;
  late RenderBox? _renderBox;
  Widget? _itemSelected;
  late Offset dropDownOffset;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          dropDownOffset = getOffset();
        });
      }
      if (widget.defaultSelectedIndex > -1) {
        if (widget.defaultSelectedIndex < widget.items.length) {
          if (mounted) {
            setState(() {
              _isAnyItemSelected = true;
              _itemSelected = Text(widget.items[widget.defaultSelectedIndex]);
              widget.onChanged?.call(widget.items[widget.defaultSelectedIndex]);
            });
          }
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _addOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = true;
      });
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
      _overlayEntry.remove();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    _renderBox = context.findRenderObject() as RenderBox?;

    var size = _renderBox!.size;

    dropDownOffset = getOffset();

    return OverlayEntry(
      maintainState: false,
      builder: (context) => Align(
        alignment: Alignment.center,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: dropDownOffset,
          child: SizedBox(
            height: widget.maxListHeight,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment:
                  _isReverse ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: widget.maxListHeight,
                      maxWidth: size.width,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.borderRadius),
                      ),
                      child: Material(
                        shadowColor: Colors.black,
                        color: Colors.black,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.items.length,
                          separatorBuilder: (context, index) => Divider(
                            color: const Color(0xFF5E5E5E).withOpacity(0.5),
                            height: 1,
                          ),
                          itemBuilder: (context, index) => InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.items[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _isAnyItemSelected = true;
                                  _itemSelected = Text(
                                    widget.items[index],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  );
                                  _removeOverlay();
                                  widget.onChanged?.call(widget.items[index]);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Offset getOffset() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    double y = renderBox!.localToGlobal(Offset.zero).dy;
    double spaceAvailable = _getAvailableSpace(y + renderBox.size.height);
    if (spaceAvailable > widget.maxListHeight) {
      _isReverse = false;
      return Offset(0, renderBox.size.height);
    } else {
      _isReverse = true;
      return Offset(
        0,
        renderBox.size.height - (widget.maxListHeight + renderBox.size.height),
      );
    }
  }

  double _getAvailableSpace(double offsetY) {
    double safePaddingTop = MediaQuery.of(context).padding.top;
    double safePaddingBottom = MediaQuery.of(context).padding.bottom;

    double screenHeight =
        MediaQuery.of(context).size.height - safePaddingBottom - safePaddingTop;

    return screenHeight - offsetY;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled
            ? () {
                _isOpen ? _removeOverlay() : _addOverlay();
              }
            : null,
        child: Container(
          decoration: _getDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: _isAnyItemSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: _itemSelected!,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          widget.hintText,
                          style: const TextStyle(
                              color: Color(0xFF5E5E5E), fontSize: 14),
                        ),
                      ),
              ),
              const Flexible(
                flex: 1,
                child: Icon(Icons.arrow_drop_down, color: Color(0xFF5E5E5E)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Decoration? _getDecoration() {
    if (_isOpen && !_isReverse) {
      return BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.borderRadius),
          topRight: Radius.circular(widget.borderRadius),
        ),
      );
    } else if (_isOpen && _isReverse) {
      return BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(widget.borderRadius),
          bottomRight: Radius.circular(widget.borderRadius),
        ),
      );
    } else if (!_isOpen) {
      return BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius),
        ),
      );
    }
    return null;
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    Key? key,
    this.radius,
    this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? const Color(0XFF1E1E1E),
          ),
          const BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black,
          ),
        ],
      ),
      child: child,
    );
  }
}
